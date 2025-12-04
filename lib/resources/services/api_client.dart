import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:reviewstation_app/resources/shared/local_storage_service.dart';

class ApiClient {
  static const String _baseUrl = 'https://api-reviewstation.onrender.com'; 
  
  // Headers padrão para todas as requisições
  static const Map<String, String> _baseHeaders = {
    'Content-Type': 'application/json',
  };

  // Injeção de dependência do serviço de armazenamento
  final LocalStorageService _localStorageService;

  ApiClient(this._localStorageService);

  // Helper para construir os headers com o token de forma dinâmica
  Future<Map<String, String>> _getHeaders({bool requiresAuth = false}) async {
    final Map<String, String> headers = Map.from(_baseHeaders);
    
    if (requiresAuth) {
      final String? token = await _localStorageService.getToken();
      if (token != null) {
        // Adiciona o token no formato Bearer
        headers['Authorization'] = 'Bearer $token'; 
      }
      // Em caso de token nulo, a API retornará 401/403, o que é esperado.
    }
    return headers;
  }
  
  // Método POST (Adaptado para segurança)

  Future<http.Response> post(String endpoint, {Map<String, dynamic>? body, bool requiresAuth = false}) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    final String jsonBody = jsonEncode(body);
    final headers = await _getHeaders(requiresAuth: requiresAuth); 

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonBody,
      );
      return response;
    } catch (e) {
      // 💡 NOVO: LOG DETALHADO DA EXCEÇÃO
      print('================================================');
      print('ERRO DE CONEXÃO NO POST PARA $endpoint:');
      print('URL: $url');
      print('EXCEÇÃO: $e');
      print('================================================');
      
      // Relança a exceção para que o ViewModel a capture
      throw Exception('Falha na comunicação com a API. Verifique a URL e a rede.');
    }
  }

  // Método GET (Não protegido, não requer requiresAuth=true)

  Future<http.Response> get(String endpoint, {Map<String, dynamic>? queryParams, bool requiresAuth = false}) async {
    // 💡 Ajustado para receber requiresAuth (útil para GET /users/:id)
    Uri url = Uri.parse('$_baseUrl$endpoint');
    
    if (queryParams != null && queryParams.isNotEmpty) {
      final String queryString = Uri(queryParameters: queryParams.map((key, value) => MapEntry(key, value.toString()))).query;
      url = Uri.parse('$_baseUrl$endpoint?$queryString');
    }
    
    final headers = await _getHeaders(requiresAuth: requiresAuth); 
    
    try {
      final response = await http.get(url, headers: headers);
      return response;
    } catch (e) {
      throw Exception('Erro de rede durante o GET para $endpoint: $e');
    }
  }

  // Método PUT (Adaptado para segurança)  

  Future<http.Response> put(String endpoint, {required Map<String, dynamic> body, bool requiresAuth = false}) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    final String jsonBody = jsonEncode(body);
    
    final headers = await _getHeaders(requiresAuth: requiresAuth); 

    try {
      final response = await http.put(
        url,
        headers: headers,
        body: jsonBody,
      );
      return response;
    } catch (e) {
      throw Exception('Erro de rede durante o PUT para $endpoint: $e');
    }
  }
  
  // Método DELETE (Adaptado para segurança)
  
  Future<http.Response> delete(String endpoint, {Map<String, dynamic>? body, bool requiresAuth = false}) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    final String jsonBody = jsonEncode(body);

    final headers = await _getHeaders(requiresAuth: requiresAuth); 

    try {
      final response = await http.delete(
        url,
        headers: headers,
        body: jsonBody,
      );
      return response;
    } catch (e) {
      throw Exception('Erro de rede durante o DELETE para $endpoint: $e');
    }
  }
}