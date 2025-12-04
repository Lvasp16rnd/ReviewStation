import 'package:flutter/material.dart';

import 'package:reviewstation_app/resources/models/review_model.dart';
import 'package:reviewstation_app/resources/shared/styles/colors.dart';
import 'package:reviewstation_app/resources/shared/styles/typography.dart';

class ReviewTile extends StatelessWidget {
  final ReviewModel review;

  const ReviewTile({
    super.key,
    required this.review,
  });

  @override
  Widget build(BuildContext context) {
    // Usar ?. para checar se 'author' é nulo antes de acessar 'fullName'
    final authorName = review.author?.fullName ?? 'Usuário Desconhecido';
    
    // Garantir que 'createdAt' não é nulo antes de formatar
    final formattedDate = '${review.createdAt.day}/${review.createdAt.month}/${review.createdAt.year}';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Autor e Data
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Nome do Autor
              Text(
                authorName,
                style: AppTypography.title.copyWith(fontSize: 16),
              ),
              // Data
              Text(
                formattedDate,
                style: AppTypography.caption,
              ),
            ],
          ),
          const SizedBox(height: 4),

          // 2. Nota (Estrelas)
          Row(
            children: [
              Icon(
                Icons.star,
                color: AppColors.secondary, // Cor de destaque para a nota
                size: 18,
              ),
              const SizedBox(width: 4),
              // Rating é um double, formatamos
              Text(
                review.rating.toStringAsFixed(1),
                style: AppTypography.bodyText.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // 3. Conteúdo do Texto
          // ✅ Correção de Segurança (Removendo o ! e usando ?? para evitar crash se textContent for null)
          Text(
            review.textContent ?? 'O autor não forneceu um comentário escrito.',
            style: AppTypography.bodyText,
            textAlign: TextAlign.justify,
          ),

          // 4. Separador
          const Divider(height: 24, thickness: 1),
        ],
      ),
    );
  }
}