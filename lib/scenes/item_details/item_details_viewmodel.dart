import 'package:flutter/material.dart';

import '../../../resources/models/item_model.dart';
import '../../../resources/services/item_service.dart';
import '../../../resources/shared/coordinator/app_coordinator.dart';
import '../../../resources/services/review_service.dart';

class ItemDetailsViewModel extends ChangeNotifier {
  // Dependências injetadas (incluindo o dado de entrada)
  final String itemId; // ID que veio da tela Home
  final ItemService itemService;
  final ReviewService reviewService;
  final AppCoordinator coordinator;

  ItemDetailsViewModel({
    required this.itemId,
    required this.itemService,
    required this.reviewService,
    required this.coordinator,
  }) {
    // Usa o itemId injetado para carregar o item
    fetchItemDetails(itemId);
  }

  // --- Estado da Tela ---
  ItemModel? _item;
  bool _isLoading = false;
  String? _errorMessage;

  ItemModel? get item => _item;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // --- Lógica de Busca e Negócios ---

  Future<void> fetchItemDetails(String id) async {
    _setLoading(true);

    try {
      // Chama a API através do ItemService (GET /item/{id})
      // Assumindo que ItemService.fetchItemDetails() está implementado
      final fetchedItem = await itemService.fetchItemDetails(id); 
      
      // Atualiza o estado
      _item = fetchedItem;

    } catch (e) {
      _errorMessage = 'Falha ao carregar detalhes: ${e.toString().replaceFirst('Exception: ', '')}';
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> submitReview({required int rating, required String text}) async {
    _setLoading(true);

    try {
        // Chama o ReviewService (que usa o JWT)
        final newReview = await reviewService.createReview(
            itemId: itemId, // Usa o ID injetado
            rating: rating,
            textContent: text,
        );

        // Se sucesso, atualiza a lista de reviews ou recarrega a tela
        // (Para simplificar, apenas retornamos sucesso e o usuário recarrega a tela)
        print('Review criada com sucesso: ${newReview.id}');
        
        // Recarregar os detalhes do item para exibir a nova review
        await fetchItemDetails(itemId); 
        
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
  // Lógica de Navegação (Intenções)
  
  void fabTapped() {
    // Chamamos o Coordinator para iniciar o fluxo de escrita de review
    // (A tela WriteReview ainda precisa ser criada)
    coordinator.navigateToWriteReview(itemId);
  }

  // Exemplo: O usuário quer voltar para a lista (Home).
  void backTapped() {
    coordinator.pop(); // Método que voltará 
  }

  // Exemplo: O usuário quer escrever uma avaliação.
  void writeReviewTapped() {
    // coordinator.navigateToWriteReview(_item!.id); 
  }
}