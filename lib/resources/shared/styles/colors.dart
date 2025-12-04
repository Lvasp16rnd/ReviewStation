import 'package:flutter/material.dart';

// Classe que define a paleta de cores do aplicativo.
class AppColors {
  // Cores Primárias (usadas para botões principais, background da AppBar)
  static const Color primary = Color(0xFF4A90E2); // Azul Vívido (Exemplo)
  static const Color primaryLight = Color(0xFF7CB8F9);
  static const Color primaryDark = Color(0xFF0066B3);

  // Cores Secundárias (para ações de destaque ou contraste)
  static const Color secondary = Color(0xFFF5A623); // Laranja/Amarelo

  // Cores de Feedback (para mensagens de sucesso/erro)
  static const Color success = Color(0xFF50E3C2); // Verde Água
  static const Color error = Color(0xFFD0021B);   // Vermelho Escuro
  static const Color warning = Color(0xFFF8E71C); // Amarelo de Alerta

  // Cores Neutras (para background, texto e bordas)
  static const Color background = Color(0xFFF0F0F0);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF333333);
  static const Color textLight = Color(0xFF9B9B9B);
}