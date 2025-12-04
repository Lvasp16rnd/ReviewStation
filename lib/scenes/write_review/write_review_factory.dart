import 'package:flutter/material.dart';

// Importa Services e Coordinator (Dependências)
import '../../../resources/services/item_service.dart';
import '../../../resources/services/review_service.dart';
import '../../../resources/shared/coordinator/app_coordinator.dart';

// Importa a View e o ViewModel que serão montados
import 'write_review_view.dart';
import 'package:reviewstation_app/scenes/write_review/wirte_review_viewmodel.dart';

class WriteReviewFactory {

  // Método 'make': Cria a View e o ViewModel
  static Widget make({
    required AppCoordinator coordinator, 
    required String itemId, 
    required ReviewService reviewService,
    // Opcional: Se a tela de review precisa carregar o nome do item
    required ItemService itemService,        
  }) {
    
    // Instancia o ViewModel, injetando o itemId e os Services
    final viewModel = WriteReviewViewModel(
      itemId: itemId, 
      reviewService: reviewService,   // Service que envia a review
      itemService: itemService,       // Service para buscar detalhes do item
      coordinator: coordinator,
    );
    
    // Retorna a View, injetando o ViewModel
    return WriteReviewView(viewModel: viewModel);
  }

  // Método 'makeRoute': Cria a rota (usado pelo AppCoordinator)
  static MaterialPageRoute makeRoute({
    required AppCoordinator coordinator, 
    required String itemId,
    required ReviewService reviewService,
    required ItemService itemService,
  }) {
    return MaterialPageRoute(
      builder: (context) => make(
        coordinator: coordinator, 
        itemId: itemId,
        reviewService: reviewService,
        itemService: itemService,
      ),
    );
  }
}