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

  // 💡 Função para obter o caminho completo do asset
  String _getAssetPath(String fileName) {
    // A API Node.js/Prisma retorna apenas o nome do arquivo, e o Flutter o monta.
    return 'assets/images/$fileName';
  }

  @override
  Widget build(BuildContext context) {
    final hasPoster = item.posterUrl != null && item.posterUrl!.isNotEmpty;

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),

        child: Column( // O Column principal precisa começar fora do Padding se a imagem for full-width
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            // 🖼️ 1. IMAGEM DO POSTER (Nova Seção)
            if (hasPoster) ...[
              ClipRRect( // Recorta a imagem para combinar com as bordas do Card
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: Image.asset(
                  _getAssetPath(item.posterUrl!),
                  height: 180, // Altura fixa para o poster
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => 
                      // Placeholder simples em caso de erro no asset
                      Container(
                        height: 180,
                        color: AppColors.background,
                        child: const Icon(Icons.image_not_supported, color: AppColors.textLight),
                      ),
                ),
              ),
            ],

            // 2. CONTEÚDO (Padding interno)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título Principal
                  Text(
                    item.title,
                    style: AppTypography.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Tipo da Mídia e Ano
                  Text(
                    '${item.type} (${item.releaseDate.year})',
                    style: AppTypography.caption,
                  ),
                  const SizedBox(height: 12),

                  // --- Rating e Contagem de Reviews ---
                  Row(
                    children: [
                      const Icon(Icons.star, color: AppColors.secondary, size: 20),
                      const SizedBox(width: 8),
                      
                      // Nota Média
                      Text(
                        item.averageRating.toStringAsFixed(1),
                        style: AppTypography.title.copyWith(color: AppColors.secondary),
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
          ],
        ),
      ),
    );
  }
}