import 'package:flutter/material.dart';

import '../../../resources/services/review_service.dart';
import '../../../resources/services/item_service.dart'; // Para carregar o nome do item
import '../../../resources/shared/coordinator/app_coordinator.dart';

class WriteReviewViewModel extends ChangeNotifier {
  // --- Dependências Injetadas ---
  final String itemId; 
  final ReviewService reviewService;
  final ItemService itemService;
  final AppCoordinator coordinator;

  WriteReviewViewModel({
    required this.itemId,
    required this.reviewService,
    required this.itemService,
    required this.coordinator,
  }) {
    // Carrega o nome do item ao iniciar a tela (para exibição no AppBar)
    _fetchItemName(); 
  }

  // --- Estado da Tela ---
  bool _isLoading = false;
  String? _errorMessage;
  String? _itemName;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get itemName => _itemName ?? 'Escrever Avaliação';

  // --- Lógica de Inicialização ---
  Future<void> _fetchItemName() async {
    try {
      final item = await itemService.fetchItemDetails(itemId);
      _itemName = item.title;
    } catch (e) {
      _itemName = 'Erro ao carregar nome';
    }
    notifyListeners();
  }

  // --- Lógica de Submissão ---

  Future<bool> handleSubmitReview({
    required int rating, 
    required String textContent,
  }) async {
    // 1. Validação simples
    if (rating < 1 || rating > 5) {
      _errorMessage = 'Selecione uma nota entre 1 e 5.';
      notifyListeners();
      return false;
    }
    
    _setLoading(true);

    try {
        // 2. Chama o ReviewService para enviar a avaliação
        await reviewService.createReview(
            itemId: itemId,
            rating: rating,
            textContent: textContent,
        );
        
        // 3. Sucesso! Fecha a tela.
        // O pop() é essencial para retornar para ItemDetailsView
        coordinator.pop(); 
        
        // 💡 Opcional: Aqui você pode notificar a ItemDetailsView para recarregar.
        // No nosso caso, o pop() fará a ItemDetailsView ser reconstruída, o que é suficiente.

        return true;

    } catch (e) {
        _errorMessage = 'Falha ao enviar review: ${e.toString().replaceFirst('Exception: ', '')}';
        _setLoading(false);
        return false;
    }
  }
  
  void _setLoading(bool value) {
    _isLoading = value;
    _errorMessage = null; 
    notifyListeners();
  }
}