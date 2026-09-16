import 'package:dio/dio.dart';

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
      ),
    );
  }

  static final ApiClient instance = ApiClient._();

  late final Dio dio;
  final StorageService storage = StorageService();

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
    try {
      return await call();
    } on DioException catch (error) {
      throw ApiException(_messageFor(error));
    }
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
