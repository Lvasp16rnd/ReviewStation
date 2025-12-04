// bottom_navigation_bar_view_model.dart

import 'package:flutter/material.dart';

// 💡 Enums mantidos conforme seu design
enum ActionBottomBarOptionSize {
  large,
  medium,
  small,
}
enum ActionBottomNavigationBarStyle {
  primary,
  secondary,
  tertiary,
}

// Classe para representar um item na Bottom Navigation Bar
class BottomBarItem {
  final IconData icon;
  final String label;

  BottomBarItem({
   required this.icon,
   required this.label,
  });
}

class ActionBottomBarViewModel {
  final ActionBottomBarOptionSize size;
  final ActionBottomNavigationBarStyle style;
  final List<BottomBarItem> items;
  int selectedIndex;
  final Function(int) onItemSelected;

  ActionBottomBarViewModel({
    required this.size,
    required this.style,
    required this.items,
    this.selectedIndex = 0,
    required this.onItemSelected,
  });
}