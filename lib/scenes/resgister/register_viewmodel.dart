import 'package:flutter/material.dart';

import '../../../resources/services/user_service.dart';
import '../../../resources/shared/coordinator/app_coordinator.dart';

class RegisterViewModel extends ChangeNotifier {
  // --- Dependências Injetadas ---
  final UserService userService;
  final AppCoordinator coordinator;

  RegisterViewModel({
    required this.userService,
    required this.coordinator,
  });

  // --- Estado da Tela ---
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // --- Lógica de Cadastro ---

  Future<void> handleRegister({
    required String email, 
    required String password, 
    required String name, 
    required int age,
  }) async {
    // 1. Validação básica (pode ser mais completa na View)
    if (email.isEmpty || password.isEmpty || name.isEmpty || age < 18) {
      _errorMessage = 'Preencha todos os campos e certifique-se de ser maior de 18.';
      notifyListeners();
      return;
    }

    _setLoading(true);

    try {
      // 2. Chama o UserService para registrar
      // Nota: userService.registerUser retorna um UserModel em caso de sucesso
      await userService.registerUser(email, password, name, age);
      
      // 3. Sucesso! Navega de volta para a tela de Login
      coordinator.pop(); // Ou navega para a Home, dependendo do fluxo
      
    } catch (e) {
      // 4. Trata erros da API (ex: Email já existe)
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _setLoading(false);
    }
  }
  
  void _setLoading(bool value) {
    _isLoading = value;
    _errorMessage = null; 
    notifyListeners();
  }
}