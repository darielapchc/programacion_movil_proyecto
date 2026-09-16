import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';

import 'api_config.dart';
import 'storage_service.dart';

class ApiException implements Exception {
  final String message;

  const ApiException(this.message);

  @override
  String toString() => message;
}

class ApiClient {
  ApiClient._() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
        headers: const {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await storage.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          final status = error.response?.statusCode;
          final options = error.requestOptions;
          final yaReintentado = options.extra['authRetry'] == true;

          if (status == 401 &&
              !yaReintentado &&
              !_esRutaPublica(options.path) &&
              !_esRutaRefresh(options.path)) {
            try {
              final nuevoToken = await _refrescarToken();
              options.extra['authRetry'] = true;
              options.headers['Authorization'] = 'Bearer $nuevoToken';

              final response = await dio.fetch<dynamic>(options);
              handler.resolve(response);
              return;
            } on DioException catch (refreshError) {
              // Solo cerramos la sesión si el refreshToken también dejó de
              // ser válido. Ante un problema de red conservamos la sesión.
              if (refreshError.response?.statusCode == 401) {
                await storage.clearToken();
              }
            } catch (_) {
              // No reemplazamos el error original por un error interno del
              // mecanismo de renovación.
            }
          }

          handler.next(error);
        },
      ),
    );
  }

  static final ApiClient instance = ApiClient._();

  late final Dio dio;
  final StorageService storage = StorageService();

  Future<void>? _cookieInitialization;
  Future<String>? _refreshInProgress;

  /// Inicializa la cookie httpOnly persistente que contiene el refreshToken.
  ///
  /// En Flutter móvil Dio no conserva cookies por sí solo. Por eso usamos
  /// PersistCookieJar para que la sesión pueda renovarse incluso después de
  /// cerrar y volver a abrir la aplicación.
  Future<void> initialize() {
    return _cookieInitialization ??= _initializeCookies();
  }

  Future<void> _initializeCookies() async {
    final directory = await getApplicationDocumentsDirectory();
    final cookieDirectory = Directory(
      '${directory.path}/lne_stock_cookies',
    );
    await cookieDirectory.create(recursive: true);

    final cookieStorage = FileStorage(cookieDirectory.path);
    final cookieJar = PersistCookieJar(storage: cookieStorage);
    dio.interceptors.insert(0, CookieManager(cookieJar));
  }

  Future<Response<dynamic>> get(String path) async {
    return _request(() => dio.get(path));
  }

  Future<Response<dynamic>> post(String path, {Object? data}) async {
    return _request(() => dio.post(path, data: data));
  }

  Future<Response<dynamic>> put(String path, {Object? data}) async {
    return _request(() => dio.put(path, data: data));
  }

  Future<Response<dynamic>> delete(String path) async {
    return _request(() => dio.delete(path));
  }

  Future<Response<dynamic>> _request(
    Future<Response<dynamic>> Function() call,
  ) async {
    await initialize();

    try {
      return await call();
    } on DioException catch (error) {
      throw ApiException(_messageFor(error));
    }
  }

  Future<String> _refrescarToken() {
    return _refreshInProgress ??= _hacerRefresh();
  }

  Future<String> _hacerRefresh() async {
    try {
      final response = await dio.post('/auth/refresh');
      final payload = responsePayload(response.data);
      if (payload is! Map) {
        throw const ApiException('No se pudo renovar la sesión.');
      }

      final token = '${payload['accessToken'] ?? payload['token'] ?? ''}';
      if (token.isEmpty) {
        throw const ApiException('No se recibió un nuevo token.');
      }

      await storage.saveToken(token);

      final user = payload['user'];
      if (user is Map && user['role'] != null) {
        await storage.saveRole('${user['role']}');
      }

      return token;
    } finally {
      _refreshInProgress = null;
    }
  }

  bool _esRutaRefresh(String path) {
    return path.endsWith('/auth/refresh');
  }

  bool _esRutaPublica(String path) {
    return path.endsWith('/auth/login') ||
        path.endsWith('/auth/register') ||
        path.endsWith('/auth/logout');
  }

  String _messageFor(DioException error) {
    final detail = _serverDetail(error.response?.data);
    final status = error.response?.statusCode;

    if (detail != null && detail.isNotEmpty) {
      return status == null ? detail : 'Error HTTP $status: $detail';
    }

    if (error.type == DioExceptionType.connectionError) {
      return 'No se pudo conectar con el servidor.';
    }

    if ({
      DioExceptionType.connectionTimeout,
      DioExceptionType.receiveTimeout,
      DioExceptionType.sendTimeout,
    }.contains(error.type)) {
      return 'El servidor tardó demasiado en responder.';
    }

    switch (error.response?.statusCode) {
      case 400:
        return 'La solicitud no es válida.';
      case 401:
        return 'Sesión expirada o no autorizada.';
      case 403:
        return 'No tienes permisos para realizar esta acción.';
      case 404:
        return 'Recurso no encontrado.';
      case 409:
        return 'La operación no se puede completar porque el inventario cambió.';
      case 500:
        return 'Ocurrió un error en el servidor.';
      default:
        return 'No se pudo completar la solicitud.';
    }
  }

  String? _serverDetail(dynamic data) {
    if (data is String && data.trim().isNotEmpty) return data.trim();
    if (data is! Map) return null;

    for (final key in ['message', 'error', 'detail']) {
      final value = data[key];
      if (value is String && value.trim().isNotEmpty) return value.trim();
      if (value is List && value.isNotEmpty) return value.join(', ');
    }
    return null;
  }
}

dynamic responsePayload(dynamic data) {
  if (data is Map<String, dynamic> && data['data'] != null) {
    return data['data'];
  }
  return data;
}
