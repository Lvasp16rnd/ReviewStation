import 'package:flutter/material.dart';

// Importa apenas as classes necessárias para montar a cena
import '../../../resources/shared/coordinator/app_coordinator.dart';
import 'login_view.dart';
import 'login_viewmodel.dart';

class LoginFactory {
  // O método make agora só precisa usar o AppCoordinator para buscar o UserService.
  static Widget make({required AppCoordinator coordinator}) {
    
    // REMOVIDO: A criação de LocalStorageService, ApiClient, e UserService.
    // Isso evita a duplicação e vazamento de memória.

    // INSTANCIAR O VIEW MODEL: Usa o UserService que está centralizado no Coordinator.
    final viewModel = LoginViewModel(
      userService: coordinator.userService, // <-- A OTIMIZAÇÃO ESTÁ AQUI!
      coordinator: coordinator,
    );

    // RETORNAR A VIEW
    return LoginView(viewModel: viewModel);
  }

  // MÉTODO makeRoute: Cria a rota para o Navigator
  static MaterialPageRoute makeRoute(AppCoordinator coordinator) {
    return MaterialPageRoute(
      // Chama o método 'make' para obter o Widget (View)
      builder: (context) => make(coordinator: coordinator), 
    );
  }
}