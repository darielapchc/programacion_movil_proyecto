import '../core/api_client.dart';
import '../core/storage_service.dart';
import '../models/usuario.dart';

class AuthService {
  final StorageService storage;
  final ApiClient client;
  AuthService({StorageService? storage})
    : storage = storage ?? StorageService(),
      client = ApiClient(storage: storage ?? StorageService());
  Future<Usuario> login(String email, String password) async {
    final json =
        await client.post(
              '/auth/login',
              body: {'email': email, 'password': password},
            )
            as Map<String, dynamic>;
    final user = Usuario.fromJson(
      Map<String, dynamic>.from(json['user'] as Map),
    );
    await storage.saveSession(json['accessToken'].toString(), user);
    return user;
  }

  Future<Usuario?> restoreSession() async {
    final token = await storage.getToken();
    if (token == null) return null;
    try {
      final response = await client.get('/auth/me');
      final data = response is Map && response['user'] is Map
          ? response['user']
          : response;
      final user = Usuario.fromJson(Map<String, dynamic>.from(data as Map));
      await storage.saveSession(token, user);
      return user;
    } on ApiException catch (error) {
      if (error.statusCode == 401) await storage.clearSession();
      return null;
    }
  }

  Future<void> logout() => storage.clearSession();
}
