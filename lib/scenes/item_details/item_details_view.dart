import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:reviewstation_app/components/review_title.dart';
import '../../../resources/shared/styles/typography.dart';
import '../../../resources/shared/styles/colors.dart';
import 'item_details_viewmodel.dart';

class ItemDetailsView extends StatelessWidget {
  final ItemDetailsViewModel viewModel;

  const ItemDetailsView({super.key, required this.viewModel});

  // Helper para o caminho da imagem
  String _getAssetPath(String fileName) {
    return 'assets/images/$fileName';
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: viewModel,
      child: Scaffold(
        appBar: AppBar(
          // Título simplificado na AppBar já que temos o título grande no corpo
          title: const Text('Detalhes'), 
        ),
        
        floatingActionButton: Consumer<ItemDetailsViewModel>(
          builder: (context, vm, child) {
            if (vm.isLoading || vm.errorMessage != null || vm.item == null) {
              return const SizedBox.shrink();
            }
            return FloatingActionButton.extended(
              onPressed: vm.fabTapped,
              icon: const Icon(Icons.rate_review),
              label: const Text('Avaliar'),
              backgroundColor: AppColors.secondary,
            );
          },
        ),

        body: Consumer<ItemDetailsViewModel>(
          builder: (context, vm, child) {
            if (vm.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (vm.errorMessage != null) {
              return Center(child: Text(vm.errorMessage!, style: AppTypography.bodyText.copyWith(color: AppColors.error)));
            }

            final item = vm.item;
            final reviews = item?.recentReviews ?? [];
            final hasPoster = item?.posterUrl != null && item!.posterUrl!.isNotEmpty;

            if (item != null) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                    // 1. CABEÇALHO (Título + Info à Esquerda | Poster à Direita)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Lado Esquerdo: Textos (Expanded para ocupar o espaço restante)
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title, 
                                style: AppTypography.headline1.copyWith(fontSize: 22), // Ajuste de tamanho se necessário
                              ),
                              const SizedBox(height: 8),
                              
                              Text(
                                '${item.type} (${item.releaseDate.year})', 
                                style: AppTypography.bodyText.copyWith(color: AppColors.textLight)
                              ),
                              const SizedBox(height: 12),
                              
                              // Rating
                              Row(
                                children: [
                                  const Icon(Icons.star, color: AppColors.secondary, size: 20),
                                  const SizedBox(width: 4),
                                  Text(
                                    item.averageRating.toStringAsFixed(1), 
                                    style: AppTypography.title.copyWith(color: AppColors.secondary, fontSize: 18)
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '(${item.totalReviews} reviews)', 
                                    style: AppTypography.caption
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(width: 16), // Espaço entre texto e imagem

                        // Lado Direito: Poster (Se existir)
                        if (hasPoster)
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                )
                              ]
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                _getAssetPath(item.posterUrl!),
                                width: 100, // Largura fixa para o poster na tela de detalhes
                                height: 150, // Altura fixa
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => const SizedBox(width: 100, height: 150),
                              ),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 16),

                    // 2. DESCRIÇÃO
                    Text('Sinopse', style: AppTypography.title),
                    const SizedBox(height: 8),
                    Text(
                      item.description, 
                      style: AppTypography.bodyText,
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 32),

                    // 3. REVIEWS
                    Text('Avaliações', style: AppTypography.title),
                    const SizedBox(height: 16),

                    if (reviews.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                          child: Text(
                            'Seja o primeiro a avaliar!', 
                            style: AppTypography.bodyText.copyWith(color: AppColors.textLight)
                          )
                        ),
                      )
                    else
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true, 
                        itemCount: reviews.length,
                        itemBuilder: (context, index) {
                          return ReviewTile(review: reviews[index]); 
                        },
                      ),
                  ],
                ),
              );
            }
            
            return Center(child: Text("Item não encontrado.", style: AppTypography.bodyText));
          },
        ),
      ),
    );
  }
}