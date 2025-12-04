import 'package:flutter/material.dart';
import 'package:reviewstation_app/resources/services/api_client.dart';
import 'package:reviewstation_app/resources/services/user_service.dart';
import 'package:reviewstation_app/resources/services/item_service.dart';
import 'package:reviewstation_app/resources/services/review_service.dart';

// Importa o Theme
import 'resources/shared/styles/app_theme.dart'; 
// Importa o Coordinator e a estrutura Application
import 'resources/shared/coordinator/app_coordinator.dart';
import 'package:reviewstation_app/resources/shared/local_storage_service.dart';


void main() {
  // 1. Instancia o Coordinator
  
  final localStorageService = LocalStorageService();
  final apiClient = ApiClient(localStorageService);
  
  // Services de Negócio
  final userService = UserService(apiClient, localStorageService);

  final itemService = ItemService(apiClient);
  final reviewService = ReviewService(apiClient);

  final coordinator = AppCoordinator(
    itemService: itemService,
    reviewService: reviewService,
    userService: userService
  );
  
  // 2. Lança a aplicação (Application é um wrapper do MaterialApp)
  runApp(Application(coordinator: coordinator));
}

// Classe Application copiada e adaptada
class Application extends StatelessWidget {
  final AppCoordinator coordinator;

  const Application({super.key, required this.coordinator});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "ReviewStation App",
      
      // USA O DESIGN SYSTEM
      theme: AppTheme.lightTheme, 
      
      // Usa a chave do Coordinator para gerenciar a navegação globalmente
      navigatorKey: coordinator.navigatorKey, 
      
      // Define a tela inicial (Login, Home, etc.)
      home: coordinator.startApp(), 
    );
  }
}