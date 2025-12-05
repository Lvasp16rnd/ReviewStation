import 'package:flutter/material.dart';

// 🚨 IMPORTS DO DESIGN SYSTEM (Ajuste o prefixo do seu pacote)
import 'package:reviewstation_app/resources/shared/styles/colors.dart'; 
import 'package:reviewstation_app/resources/shared/styles/typography.dart'; 

import 'bottom_navigation_bar_view_model.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final ActionBottomBarViewModel viewModel;

  const CustomBottomNavigationBar._(this.viewModel);

  @override
  _CustomBottomNavigationBarState createState() => _CustomBottomNavigationBarState();

  // Método para instanciar o widget com o ViewModel apropriado
  static Widget instantiate({required ActionBottomBarViewModel viewModel}) {
    return CustomBottomNavigationBar._(viewModel);
  }
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {

  // Helper para definir a cor base do estilo
  Color _getStyleColor(ActionBottomNavigationBarStyle style) {
    switch (style) {
      case ActionBottomNavigationBarStyle.primary:
        return AppColors.primary;
      case ActionBottomNavigationBarStyle.secondary:
        return AppColors.secondary;
      case ActionBottomNavigationBarStyle.tertiary:
        return AppColors.textLight; // Exemplo de cor terciária
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedColor = _getStyleColor(widget.viewModel.style);
    final unselectedColor = AppColors.textLight;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      // Cor de fundo: Superfície branca/clara do Design System
      color: AppColors.surface, 
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(widget.viewModel.items.length, (index) {
          final item = widget.viewModel.items[index];
          final isSelected = index == widget.viewModel.selectedIndex;

          return GestureDetector(
            onTap: () {
              setState(() {
                // Lógica interna do mini-MVVM para atualização de estado
                widget.viewModel.selectedIndex = index;
                widget.viewModel.onItemSelected(index);
              });
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Ícone
                Icon(
                  item.icon,
                  color: isSelected ? selectedColor : unselectedColor,
                  size: _getIconSize(widget.viewModel.size), // Usa a lógica de tamanho
                ),
                const SizedBox(height: 4),
                // Texto
                Text(
                  item.label,
                  style: AppTypography.caption.copyWith( // Usa um estilo base do Design System
                    fontSize: _getFontSize(widget.viewModel.size),
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                   color: isSelected ? selectedColor : unselectedColor,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  double _getFontSize(ActionBottomBarOptionSize size) {
    switch (size) {
      case ActionBottomBarOptionSize.large:
        return 14; // Tamanhos adaptados para mobile
      case ActionBottomBarOptionSize.medium:
        return 12;
      case ActionBottomBarOptionSize.small:
        return 10;
      default:
        return 12;
    }
  }

  double _getIconSize(ActionBottomBarOptionSize size) {
    switch (size) {
      case ActionBottomBarOptionSize.large:
        return 28;
      case ActionBottomBarOptionSize.medium:
        return 24;
      case ActionBottomBarOptionSize.small:
        return 20;
      default:
         return 24;
     }
  }
}
