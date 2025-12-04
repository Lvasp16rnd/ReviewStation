import 'package:flutter/material.dart';

// Importa as dependências (já injetadas no AppCoordinator)
import '../../../resources/services/user_service.dart';
import '../../../resources/shared/coordinator/app_coordinator.dart';

// Importa a View e o ViewModel
import 'register_view.dart';
import 'register_viewmodel.dart';

class RegisterFactory {

  // Método 'make' para montar a Scene
  static Widget make({
    required AppCoordinator coordinator,
    required UserService userService, // Requer o UserService para a lógica de cadastro
  }) {
    
    // Instancia o ViewModel, injetando o Service e o Coordinator
    final viewModel = RegisterViewModel(
      userService: userService,
      coordinator: coordinator,
    );

    // Retorna a View
    return RegisterView(viewModel: viewModel);
  }

  // Método para criar a rota (usado pelo AppCoordinator)
  static MaterialPageRoute makeRoute({
    required AppCoordinator coordinator,
    required UserService userService,
  }) {
    return MaterialPageRoute(
      builder: (context) => make(
        coordinator: coordinator,
        userService: userService,
      ),
    );
  }
}