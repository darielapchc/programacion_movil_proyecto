import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'api_config.dart';
import 'storage_service.dart';

class ApiException implements Exception {
  final int? statusCode;
  final String message;
  ApiException(this.message, {this.statusCode});
}

class ApiClient {
  final StorageService storage;
  ApiClient({StorageService? storage}) : storage = storage ?? StorageService();
  Future<dynamic> get(String path, {Map<String, String>? queryParameters}) =>
      _request('GET', path, queryParameters: queryParameters);
  Future<dynamic> post(String path, {Map<String, dynamic>? body}) =>
      _request('POST', path, body: body);
  Future<dynamic> put(String path, {Map<String, dynamic>? body}) =>
      _request('PUT', path, body: body);
  Future<dynamic> delete(String path) => _request('DELETE', path);
  Future<dynamic> _request(
    String method,
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? queryParameters,
  }) async {
    final uri = Uri.parse(
      '${ApiConfig.baseUrl}/api$path',
    ).replace(queryParameters: queryParameters);
    final token = await storage.getToken();
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    try {
      final response = await switch (method) {
        'GET' => http.get(uri, headers: headers),
        'POST' => http.post(
          uri,
          headers: headers,
          body: jsonEncode(body ?? {}),
        ),
        'PUT' => http.put(uri, headers: headers, body: jsonEncode(body ?? {})),
        'DELETE' => http.delete(uri, headers: headers),
        _ => throw ApiException('Método HTTP no soportado'),
      };
      dynamic decoded;
      if (response.body.isNotEmpty) decoded = jsonDecode(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return decoded;
      }
      final message = decoded is Map<String, dynamic>
          ? (decoded['message'] ?? decoded['error'] ?? 'Error del servidor')
                .toString()
          : 'Error del servidor';
      throw ApiException(message, statusCode: response.statusCode);
    } on SocketException {
      throw ApiException('No fue posible conectar con el servidor.');
    } on http.ClientException {
      throw ApiException('No fue posible conectar con el servidor.');
    } on FormatException {
      throw ApiException('El servidor devolvió una respuesta inválida.');
    }
  }

  static List<dynamic> asList(dynamic response) {
    if (response is List) return response;
    if (response is Map<String, dynamic>) {
      final value = response['data'] ?? response['items'] ?? response['rows'];
      if (value is List) return value;
    }
    return const [];
  }
}
