import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const _tokenKey = 'jwt_token';

  // Salva o JWT retornado pela rota POST /auth/login
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  // Recupera o JWT para enviar nas requisições protegidas
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Remove o token (Usado no Logout)
  Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
}