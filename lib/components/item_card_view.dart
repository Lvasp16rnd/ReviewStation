import 'package:flutter/material.dart';

import 'package:reviewstation_app/resources/models/item_model.dart';
import 'package:reviewstation_app/resources/shared/styles/colors.dart';
import 'package:reviewstation_app/resources/shared/styles/typography.dart';

class ItemCardView extends StatelessWidget {
  final ItemModel item;
  final VoidCallback onTap;

  const ItemCardView({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      
      child: InkWell( // Permite o efeito visual ao ser clicado
        onTap: onTap, // Chama o callback para navegar para detalhes
        borderRadius: BorderRadius.circular(10),

        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título Principal
              Text(
                item.title,
                style: AppTypography.title, // Estilo de título
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),

              // Tipo da Mídia e Ano
              Text(
                // Usando o campo 'releaseDate' para o ano
                '${item.type} (${item.releaseDate.year})',
                style: AppTypography.caption, // Estilo de legenda
              ),
              const SizedBox(height: 12),

              // --- Rating e Contagem de Reviews ---
              Row(
                children: [
                  const Icon(Icons.star, color: AppColors.secondary, size: 20),
                  const SizedBox(width: 8),
                  
                  // Nota Média
                  Text(
                    item.averageRating.toStringAsFixed(1), // Ex: 4.5
                    style: AppTypography.title.copyWith(color: AppColors.secondary), // Cor de destaque
                  ),
                  const SizedBox(width: 8),
                  
                  // Contagem de Reviews
                  Text(
                    '(${item.totalReviews} avaliações)',
                    style: AppTypography.caption.copyWith(color: AppColors.textLight),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}