import 'package:flutter/material.dart';
import 'colors.dart';
import 'typography.dart';

// Classe que define o tema visual principal do aplicativo.
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      // Cores Primárias e de Brilho
      primaryColor: AppColors.primary,
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        background: AppColors.background,
        error: AppColors.error,
        surface: AppColors.surface,
      ),

      // Configuração de Tipografia
      fontFamily: AppTypography.fontFamily,
      textTheme: TextTheme(
        headlineLarge: AppTypography.headline1,
        headlineMedium: AppTypography.headline2,
        titleLarge: AppTypography.title,
        bodyMedium: AppTypography.bodyText,
        labelLarge: AppTypography.buttonText,
        bodySmall: AppTypography.caption,
      ),

      // Estilo da AppBar
      appBarTheme: AppBarTheme(
        color: AppColors.primary,
        titleTextStyle: AppTypography.title.copyWith(color: AppColors.surface),
        iconTheme: const IconThemeData(color: AppColors.surface),
      ),

      // Estilo de Botões Elevados
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.surface,
          textStyle: AppTypography.buttonText,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),

      // Configurações gerais
      scaffoldBackgroundColor: AppColors.background,
    );
  }
}