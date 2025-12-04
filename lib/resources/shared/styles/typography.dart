import 'package:flutter/material.dart';
import 'colors.dart';

// Classe que define a hierarquia de texto do aplicativo.
class AppTypography {
  static const String fontFamily = 'Roboto'; // Exemplo de fonte

  // Estilo base para textos escuros (padrão)
  static const TextStyle _baseTextStyle = TextStyle(
    fontFamily: fontFamily,
    color: AppColors.textDark,
  );

  // Títulos
  static TextStyle headline1 = _baseTextStyle.copyWith(
    fontSize: 28.0,
    fontWeight: FontWeight.w700, // Bold
  );

  static TextStyle headline2 = _baseTextStyle.copyWith(
    fontSize: 24.0,
    fontWeight: FontWeight.w600,
  );

  // Subtítulo e texto da AppBar
  static TextStyle title = _baseTextStyle.copyWith(
    fontSize: 18.0,
    fontWeight: FontWeight.w500,
  );

  // Texto do corpo principal
  static TextStyle bodyText = _baseTextStyle.copyWith(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
  );

  // Texto de botões ou campos menores
  static TextStyle buttonText = _baseTextStyle.copyWith(
    fontSize: 16.0,
    fontWeight: FontWeight.w700,
    color: AppColors.surface, // Branco para contraste
  );
  
  // Texto secundário (legendas, hints)
  static TextStyle caption = _baseTextStyle.copyWith(
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    color: AppColors.textLight,
  );
}