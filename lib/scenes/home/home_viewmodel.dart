import 'package:flutter/material.dart';

import '../../../resources/models/item_model.dart';
import '../../../resources/services/item_service.dart';
import '../../../resources/shared/coordinator/app_coordinator.dart';

class HomeViewModel extends ChangeNotifier {
  // Dependências injetadas
  final ItemService itemService;
  final AppCoordinator coordinator;

  HomeViewModel({
    required this.itemService,
    required this.coordinator,
  }) {
    // Chama a busca ao inicializar o ViewModel
    fetchItems();
  }

  // --- Estado da Tela ---
  List<ItemModel> _items = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ItemModel> get items => _items;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // --- Lógica de Busca e Negócios ---
  Future<void> fetchItems() async {
    _setLoading(true);

    try {
      // Chama a API através do ItemService (GET /item)
      final fetchedItems = await itemService.fetchItemList();
      
      // Atualiza o estado
      _items = fetchedItems;

    } catch (e) {
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
  
  
  // Lógica de Navegação (Intenções)
  
  
  // Chamado quando o usuário clica em um item.
  void itemTapped(String itemId) {
    coordinator.navigateToItemDetails(itemId);
  }

  // Chamado quando o usuário clica em Logout.
  void logoutTapped() {
    // Lógica: Limpar o token JWT localmente
    // ...
    coordinator.navigateToLogin(); // Retorna à tela de Login
  }
}