import 'package:flutter/material.dart';

// Importa o Design System
import 'package:reviewstation_app/resources/shared/styles/colors.dart';
import 'package:reviewstation_app/resources/shared/styles/typography.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed; // VoidCallback? para botões que podem estar desativados
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Ocupa toda a largura
      height: 50,
      child: ElevatedButton(
        // Se estiver carregando, onPressed é null (botão desativado)
        onPressed: isLoading ? null : onPressed, 
        style: ElevatedButton.styleFrom(
          // Usa os estilos definidos no AppTheme (mas aqui reforçamos o foreground para loading)
          backgroundColor: AppColors.primary, 
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: isLoading
            ? const Center(
                // Usa a cor do texto do AppTheme para o indicador
                child: CircularProgressIndicator(
                  color: AppColors.surface, 
                  strokeWidth: 2.5,
                ),
              )
            : Text(
                text,
                style: AppTypography.buttonText,
              ),
      ),
    );
  }
}