import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Importa o Design System
import 'package:reviewstation_app/resources/shared/styles/colors.dart';
// Importa o ViewModel (Ajuste o caminho se for diferente)
import 'package:reviewstation_app/scenes/home/home_viewmodel.dart'; 
// Usando o HomeViewModel como exemplo, pois ele gerencia o estado da Home.

// Nota: O componente deve ser um StatelessWidget que recebe o estado.
// Vamos assumir que ele recebe a contagem e o onPressed.

class BadgeButton extends StatelessWidget {
  final int notificationCount;
  final VoidCallback onPressed;
  
  // 💡 Recomendação: Remover o ViewModel interno se a contagem for gerenciada
  // pelo ViewModel da Scene (ex: HomeViewModel) e for passada para cá.

  const BadgeButton({
    super.key,
    required this.notificationCount,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    // Usa o onPressed injetado, removendo a lógica de navegação acoplada
    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          icon: const Icon(
            Icons.notifications,
            color: AppColors.textDark, // Usa a cor do seu Design System
          ),
          onPressed: onPressed, // Chama o callback injetado
        ),
        
        // Exibe o badge se houver notificações
        if (notificationCount > 0)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                // Usa a cor de erro/destaque do Design System
                color: AppColors.error, 
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.surface, width: 1.5), // Borda branca para destaque
              ),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Text(
                // Limita a exibição se o número for muito grande
                notificationCount > 99 ? '99+' : '$notificationCount', 
                style: const TextStyle(
                    // Usa cores do Design System
                    color: AppColors.surface, 
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}