import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/usuario.dart';

class StorageService {
  static const _tokenKey = 'accessToken';
  static const _userKey = 'user';
  Future<void> saveSession(String token, Usuario user) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_tokenKey, token);
    await p.setString(_userKey, jsonEncode(user.toJson()));
  }

  Future<String?> getToken() async =>
      (await SharedPreferences.getInstance()).getString(_tokenKey);
  Future<Usuario?> getUser() async {
    final raw = (await SharedPreferences.getInstance()).getString(_userKey);
    return raw == null
        ? null
        : Usuario.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> clearSession() async {
    final p = await SharedPreferences.getInstance();
    await p.remove(_tokenKey);
    await p.remove(_userKey);
  }
}
