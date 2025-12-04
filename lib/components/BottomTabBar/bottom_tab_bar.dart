import 'package:flutter/material.dart';

// Usa o caminho absoluto do Design System
import 'package:reviewstation_app/resources/shared/styles/colors.dart'; 
import 'package:reviewstation_app/resources/shared/styles/typography.dart'; 

import 'bottom_tab_bar_view_model.dart';


class BottomTabBar extends StatelessWidget {
  final BottomTabBarViewModel viewModel;
  final int currentIndex;

  const BottomTabBar._({super.key, required this.viewModel, required this.currentIndex});

  static Widget instantiate({required BottomTabBarViewModel viewModel, required int currentIndex}) {
    return BottomTabBar._(viewModel: viewModel, currentIndex: currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    // Definimos as cores usando o Design System
    final selectedColor = AppColors.primary; // Cor principal para o item selecionado
    final unselectedColor = AppColors.textLight; // Cor neutra para o item não selecionado
    final backgroundColor = AppColors.surface; // Fundo branco

    return BottomNavigationBar(
      items: viewModel.bottomTabs,
      
      // Tipo de Layout (fixo para manter os itens estáticos)
      type: BottomNavigationBarType.fixed,
      
      // Aplicação das Cores do Design System
      selectedItemColor: selectedColor,
      unselectedItemColor: unselectedColor,
      backgroundColor: backgroundColor,

      // Aplicação do Estilo de Texto
      selectedLabelStyle: AppTypography.caption.copyWith(fontWeight: FontWeight.bold),
      unselectedLabelStyle: AppTypography.caption,
      
      showUnselectedLabels: true,
      currentIndex: currentIndex,
      onTap: viewModel.onIndexChanged,
    );
  }
}