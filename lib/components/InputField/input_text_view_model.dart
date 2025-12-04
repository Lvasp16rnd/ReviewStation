import 'package:flutter/material.dart';

class InputTextViewModel {
  final TextEditingController controller;
  final String placeholder;
  bool password;
  final Widget? suffixIcon;
  final bool isEnabled;
  final String? Function(String?)? validator;
  // A propriedade 'togglePasswordVisibility' foi removida,
  // pois a lógica é gerenciada internamente no widget 'StyledInputFieldState'.

  InputTextViewModel({
    required this.controller,
    required this.placeholder,
    required this.password,
    this.suffixIcon,
    this.isEnabled = true,
    this.validator,
  });
}