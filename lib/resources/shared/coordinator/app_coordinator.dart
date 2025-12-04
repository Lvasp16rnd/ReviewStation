import 'package:flutter/material.dart';

// Importa Services
import '../../../resources/services/item_service.dart'; 
import '../../../resources/services/review_service.dart';
import '../../../resources/services/user_service.dart';

// Importa os Factories das Scenes
import '../../../scenes/login/login_factory.dart'; 
import '../../../scenes/home/home_factory.dart'; 
import '../../../scenes/item_details/item_details_factory.dart'; 
import 'package:reviewstation_app/scenes/resgister/resgister_factory.dart';
import 'package:reviewstation_app/scenes/write_review/write_review_factory.dart';


// CLASSE BASE (Opcional, mas útil para tipagem)
abstract class Coordinator {
  // Chamado para iniciar o fluxo de navegação
  Widget startApp();
  
  // Métodos de navegação pública (interface do Coordinator)
  void navigateToHome();
  void navigateToLogin();
  void navigateToItemDetails(String itemId);
  void navigateToRegister();
  void navigateToWriteReview(String itemId);

  void pop();
}

// APP COORDINATOR (Implementação)

class AppCoordinator implements Coordinator {
  
  // Chave Global que permite navegar de qualquer lugar 
  // (mesmo fora de um Widget)
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // Helper para obter o Navigator a partir da chave global
  NavigatorState? get _navigator => navigatorKey.currentState;

  final ItemService itemService;
  final ReviewService reviewService;
  final UserService userService;


  AppCoordinator({
    required this.itemService,
    required this.reviewService,
    required this.userService,
  });

  // INÍCIO DA APLICAÇÃO (Usado no main.dart)

  @override
  Widget startApp() {
    // Lógica Futura: Aqui você checaria se o usuário está logado.
    // final isLogged = await checkAuthToken(); 
    // if (isLogged) return HomeFactory.make(coordinator: this);
    // else return LoginFactory.make(coordinator: this);

    // Por enquanto, começamos no Login
    return LoginFactory.make(coordinator: this);
  }

  // MÉTODOS DE FLUXO E NAVEGAÇÃO
 
  // Chamado pelo LoginViewModel em caso de sucesso
  @override
  void navigateToHome() {
    final route = HomeFactory.makeRoute(this);
    
    // pushReplacement remove o Login da pilha, 
    // impedindo que o usuário volte para ele
    _navigator?.pushReplacement(route); 
  }

  // Chamado pelo HomeViewModel em caso de Logout 
  //ou pelo AppCoordinator ao iniciar
  @override
  void navigateToLogin() {
    final route = LoginFactory.makeRoute(this);
    // pushReplacement remove o Home da pilha
    _navigator?.pushReplacement(route);
  }
  
  // Chamado pelo HomeViewModel quando um item é clicado
  @override
  void navigateToItemDetails(String itemId) {
     // Implementação final da rota:
     final route = ItemDetailsFactory.makeRoute(
      coordinator: this,
      itemId: itemId,
      itemService: itemService,
      reviewService: reviewService,
     );
    // Navega para a nova tela
    _navigator?.push(route);
  }

  @override
  void navigateToRegister() {
    final route = RegisterFactory.makeRoute(
        coordinator: this,
        userService: userService, // Passa o UserService centralizado
    );
    _navigator?.push(route);
}

  @override
  void navigateToWriteReview(String itemId) {
    final route = WriteReviewFactory.makeRoute(
      coordinator: this,
      itemId: itemId, // Passa o ID do Item que será avaliado
      reviewService: reviewService, // Passa o serviço que fará a requisição POST
      itemService: itemService, // Opcional, caso a tela precise de dados do item
    );
    _navigator?.push(route);
  }

  // Implementação do método de retorno
  @override
  void pop() {
    // Chama o pop do Navigator. Se não houver
    // tela anterior, ele faz nada.
    _navigator?.pop();
  }
}