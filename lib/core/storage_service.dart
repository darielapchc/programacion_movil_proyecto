import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const _tokenKey = 'accessToken';
  static const _roleKey = 'userRole';

  Future<void> saveToken(String token) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_tokenKey, token);
  }

  Future<String?> getToken() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(_tokenKey);
  }

  Future<void> saveRole(String role) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_roleKey, role);
  }

  Future<String?> getRole() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(_roleKey);
  }

  Future<void> clearToken() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_tokenKey);
    await preferences.remove(_roleKey);
  }
}
