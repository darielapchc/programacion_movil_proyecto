import '../core/api_client.dart';
import '../models/usuario.dart';

class AuthResult {
  final String accessToken;
  final Usuario user;

  const AuthResult(this.accessToken, this.user);
}

class AuthService {
  final ApiClient api;

  AuthService({ApiClient? api}) : api = api ?? ApiClient.instance;

  //Metodo Login
  Future<AuthResult> login(String email, String password) async {
    final response = await api.post(
      '/auth/login',
      data: {'email': email, 'password': password},
    );
    final payload = responsePayload(response.data) as Map<String, dynamic>;
    final token = '${payload['accessToken'] ?? payload['token'] ?? ''}';
    final user = Usuario.fromJson(
      (payload['user'] as Map?)?.cast<String, dynamic>() ?? {},
    );

    await api.storage.saveToken(token);
    await api.storage.saveRole(user.role);
    return AuthResult(token, user);
  }

  //Metodo registro
  Future<AuthResult> register({ required String fullName, required String email, required String password,}) async {
    final response = await api.post(
      '/auth/register',
      data: {'fullName': fullName, 'email': email, 'password': password, 'role': 'staff'},
    );

    final payload = responsePayload(response.data) as Map<String, dynamic>;
    final token = '${payload['accessToken'] ?? payload['token'] ?? ''}';
    final user = Usuario.fromJson((payload['user'] as Map?)?.cast<String, dynamic>() ?? {},);

    return AuthResult(token, user);
  }

  Future<Usuario> me() async {
    final response = await api.get('/auth/me');
    final usuario = _usuarioFromResponse(response.data);
    await api.storage.saveRole(usuario.role);
    return usuario;
  }

  Future<Usuario> updateMe({
    required String fullName,
    required String email,
  }) async {
    final response = await api.put(
      '/auth/me',
      data: {
        'fullName': fullName,
        'email': email,
      },
    );
    return _usuarioFromResponse(response.data);
  }

  Usuario _usuarioFromResponse(dynamic data) {
    final payload = responsePayload(data);
    final userData = payload is Map && payload['user'] is Map
        ? payload['user']
        : payload;
    return Usuario.fromJson((userData as Map).cast<String, dynamic>());
  }

  Future<void> logout() async {
    try {
      await api.post('/auth/logout');
    } finally {
      await api.storage.clearToken();
    }
  }
}
