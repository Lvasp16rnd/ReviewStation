import 'package:flutter/material.dart';

// Importa Services e Coordinator (Dependências)
import '../../../resources/services/item_service.dart';
import '../../../resources/services/review_service.dart';
import '../../../resources/shared/coordinator/app_coordinator.dart';

// Importa a View e o ViewModel que serão montados
import 'item_details_view.dart';
import 'item_details_viewmodel.dart';

class ItemDetailsFactory {

  // Método 'make': Cria a View e o ViewModel
  // Recebe todas as dependências via argumento (Injeção de Dependência)
  static Widget make({
    required AppCoordinator coordinator, 
    required String itemId, 
    required ItemService itemService,        
    required ReviewService reviewService,    
  }) {
    
    // Instancia o ViewModel, injetando o itemId e todos os Services
    final viewModel = ItemDetailsViewModel(
      itemId: itemId, 
      itemService: itemService,       // Service injetado
      reviewService: reviewService,   // Service injetado
      coordinator: coordinator,
    );
    
    // Retorna a View, injetando o ViewModel
    return ItemDetailsView(viewModel: viewModel);
  }

  // Método 'makeRoute': Cria a rota (usado pelo AppCoordinator)
  static MaterialPageRoute makeRoute({
    required AppCoordinator coordinator, 
    required String itemId,
    required ItemService itemService, 
    required ReviewService reviewService,
  }) {
    return MaterialPageRoute(
      builder: (context) => make(
        coordinator: coordinator, 
        itemId: itemId,
        itemService: itemService, // Passando o ItemService
        reviewService: reviewService, // Passando o ReviewService
      ),
    );
  }
}