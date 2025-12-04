import 'package:flutter/material.dart';

import '../../../resources/services/user_service.dart';
import '../../../resources/shared/coordinator/app_coordinator.dart';

class LoginViewModel extends ChangeNotifier {
  // Dependências injetadas
  final UserService userService;
  final AppCoordinator coordinator;

  LoginViewModel({
    required this.userService,
    required this.coordinator,
  });

  // --- Estado da Tela ---
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // --- Lógica de Negócios e Apresentação ---

  Future<void> handleLogin(String email, String password) async {
    // Validação
    if (email.isEmpty || password.isEmpty) {
      _errorMessage = 'E-mail e senha são obrigatórios.';
      notifyListeners();
      return;
    }

    _setLoading(true);

    try {
      // 2. Chama o UserService para autenticar e salvar o token.
      // ✅ CORRIGIDO: Chamada agora usa argumentos nomeados
      final bool success = await userService.loginUser(email: email, password: password);
      
      if (success) {
        // 3. Sucesso! Notifica o Coordinator para mudar o fluxo (HomeScene).
        coordinator.navigateToHome();
      } else {
        // Se o UserService retornar false (falha na API, sem erro de rede)
        _errorMessage = 'Login falhou. Verifique suas credenciais.';
      }

    } catch (e) {
      // 4. Trata erros de rede ou exceções lançadas pelo UserService/ApiClient
      _errorMessage = 'Erro de conexão: ${e.toString().replaceFirst('Exception: ', '')}';
    } finally {
      _setLoading(false);
    }
  }
  
  void _setLoading(bool value) {
    _isLoading = value;
    _errorMessage = null;
    notifyListeners();
  }
  
  void goToRegister() {
    coordinator.navigateToRegister(); 
  }
}