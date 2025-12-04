import 'package:flutter/material.dart';

import '../../../resources/services/item_service.dart';
import '../../../resources/services/api_client.dart';
import '../../../resources/services/review_service.dart';
import '../../../resources/shared/local_storage_service.dart';
import '../../../resources/shared/coordinator/app_coordinator.dart';

import 'home_view.dart';
import 'home_viewmodel.dart';

class HomeFactory {
  // Recebe o Coordinator para gerenciar o fluxo de navegação (ex: Logout)
  static Widget make({required AppCoordinator coordinator}) {

    final localStorageService = LocalStorageService();
    // Instancia as dependências (Services)
    final apiClient = ApiClient(localStorageService); // Cliente HTTP base
    final itemService = ItemService(apiClient); // Service de catálogo

    final reviewService = ReviewService(apiClient); // Service de avaliações

    // Instancia o ViewModel, injetando o Service e o Coordinator
    final viewModel = HomeViewModel(
      itemService: itemService,
      coordinator: coordinator,
    );

    // Retorna a View, injetando o ViewModel
    return HomeView(viewModel: viewModel);
  }
  
  // Método para criar a rota de navegação
  static MaterialPageRoute makeRoute(AppCoordinator coordinator) {
    return MaterialPageRoute(builder: (context) => make(coordinator: coordinator));
  }
}