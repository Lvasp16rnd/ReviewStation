// 💾 action_button.dart (Corrigido e Temático)

import 'package:flutter/material.dart';

// Importa o ViewModel
import 'action_button_view_model.dart'; 
// 🚨 IMPORTS DO DESIGN SYSTEM CORRIGIDOS
import 'package:reviewstation_app/resources/shared/styles/colors.dart';
import 'package:reviewstation_app/resources/shared/styles/typography.dart';

class ActionButton extends StatelessWidget {
    final ActionButtonViewModel viewModel;

    const ActionButton._({super.key, required this.viewModel});

    static Widget instantiate({required ActionButtonViewModel viewModel}) {
        return ActionButton._(viewModel: viewModel);
    }

    // 💡 Helper para definir o TextStyle baseado no Size
    TextStyle _getTextStyle(ActionButtonSize size) {
        switch (size) {
            case ActionButtonSize.large:
                // Usar um estilo grande do seu AppTypography (ex: headline2, ajustado para botão)
                return AppTypography.headline2.copyWith(color: AppColors.surface); 
            case ActionButtonSize.medium:
                // Estilo padrão de botão
                return AppTypography.buttonText; 
            case ActionButtonSize.small:
                // Estilo menor
                return AppTypography.caption.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.surface,
                );
            default:
                return AppTypography.buttonText;
        }
    }

    // 💡 Helper para definir a cor base do botão
    Color _getButtonColor(ActionButtonStyle style) {
        switch (style) {
            case ActionButtonStyle.primary:
                return AppColors.primary;
            case ActionButtonStyle.secondary:
                return AppColors.secondary;
            case ActionButtonStyle.tertiary:
                // Usar uma cor neutra ou clara do seu Design System
                return AppColors.textLight; 
            default:
                return AppColors.primary;
        }
    }

    @override
    Widget build(BuildContext context) {
        double horizontalPadding = 32;
        double verticalPadding = 12;
        double iconSize = 24;

        // 1. Aplica Estilo e Cor
        TextStyle buttonTextStyle = _getTextStyle(viewModel.size);
        Color buttonColor = _getButtonColor(viewModel.style);

        // 2. Lógica de Tamanho
        switch (viewModel.size) {
            case ActionButtonSize.large:
                // buttonTextStyle já foi definido
                iconSize = 24;
                break;
            case ActionButtonSize.medium:
                // buttonTextStyle já foi definido
                iconSize = 24;
                break;
            case ActionButtonSize.small:
                // Ajusta o padding para botões pequenos
                horizontalPadding = 16;
                iconSize = 16;
                break;
            default:
        }

        return ElevatedButton(
            onPressed: viewModel.onPressed,
            style: ElevatedButton.styleFrom(
                // 🎨 Aplica a cor do Design System
                backgroundColor: buttonColor,
                // 🎨 Define a cor do texto/ícone (contraste com buttonColor)
                foregroundColor: AppColors.surface, 
                // Forma
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                // Estilo de texto
                textStyle: buttonTextStyle,
                padding: EdgeInsets.symmetric(
                    vertical: verticalPadding,
                    horizontal: horizontalPadding
                )
            ),
            child: viewModel.icon != null ?
            Row(
                mainAxisSize: MainAxisSize.min, // Para evitar que o Row ocupe 100% da largura
                children: [
                    Icon(
                        viewModel.icon,
                        size: iconSize,
                    ),
                    const SizedBox(width: 8), // Espaçamento entre ícone e texto
                    Text(viewModel.text)
                ],
            ) :
            Text(viewModel.text),
        );
    }
}