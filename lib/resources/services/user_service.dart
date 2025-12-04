import 'dart:convert';
import 'package:http/http.dart' as http;

// Importa o cliente HTTP base e o modelo de usuário
import 'package:reviewstation_app/resources/services/api_client.dart';
import 'package:reviewstation_app/resources/shared/local_storage_service.dart';
import 'package:reviewstation_app/resources/models/user_model.dart';

// O UserService lida com toda a lógica relacionada ao recurso /users
class UserService {
  final ApiClient _apiClient;
  final LocalStorageService _localStorageService;

  // Injeção de Dependência: Recebe o ApiClient no construtor
  UserService(this._apiClient, this._localStorageService);

  // Cadastro de Usuário (POST /users)
  Future<UserModel> registerUser(String email, String password, String name, int age) async {
    const endpoint = '/users';
    
    final body = {
      'email': email,
      'password': password,
      'name': name,
      'age': age,
    };

    final http.Response response = await _apiClient.post(endpoint, body: body);

    print('HTTP Status Code Recebido: ${response.statusCode}');

    if (response.statusCode == 201) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return UserModel.fromJson(jsonResponse);
    } else if (response.statusCode == 400) {
      final Map<String, dynamic> error = jsonDecode(response.body);
      throw Exception('Falha no cadastro: ${error['message'] ?? 'Erro desconhecido.'}');
    } else {
      throw Exception('Falha ao criar usuário. Código HTTP: ${response.statusCode}');
    }
  }

  // 2. Login de Usuário (POST /auth/login)
  Future<bool> loginUser({required String email, required String password}) async {
    const endpoint = '/auth/login';
    
    final body = {
      'email': email,
      'password': password,
    };

    final http.Response response = await _apiClient.post(endpoint, body: body);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      // final user = UserModel.fromJson(jsonResponse['user']); // Não é obrigatório aqui, mas útil.
      final token = jsonResponse['token'] as String;
      
      // Salva o token
      await _localStorageService.saveToken(token);

      // Retorna sucesso
      return true;
      
    } else if (response.statusCode == 401) {
      // Falha de credenciais, retorna falso para ser tratado pelo ViewModel
      return false; 
    } else {
      throw Exception('Falha no login. Código HTTP: ${response.statusCode}');
    }
  }

  // Obter Detalhes do Usuário (GET /users/:id)
  Future<UserModel> fetchUserDetails(String userId) async {
    final endpoint = '/users/$userId';
    
    final http.Response response = await _apiClient.get(endpoint, requiresAuth: true);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return UserModel.fromJson(jsonResponse);
    } else if (response.statusCode == 404) {
      throw Exception('Usuário não encontrado.');
    } else {
      throw Exception('Erro ao buscar detalhes do usuário.');
    }
  }
}