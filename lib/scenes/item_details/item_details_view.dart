import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Importa Components e Design System
import 'package:reviewstation_app/components/review_title.dart';
import '../../../resources/shared/styles/typography.dart';
import '../../../resources/shared/styles/colors.dart';
import 'item_details_viewmodel.dart';

class ItemDetailsView extends StatelessWidget {
  final ItemDetailsViewModel viewModel;

  const ItemDetailsView({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: viewModel,
      child: Scaffold(
        appBar: AppBar(
          title: Consumer<ItemDetailsViewModel>(
            builder: (context, vm, child) => Text(vm.item?.title ?? 'Detalhes do Item'),
          ),
        ),
        
        // FloatingActionButton
        floatingActionButton: Consumer<ItemDetailsViewModel>(
          builder: (context, vm, child) {
            if (vm.isLoading || vm.errorMessage != null || vm.item == null) {
              return const SizedBox.shrink();
            }
            // 🚨 Este botão chama a navegação para o formulário de review
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
            
            // Estado de Carregamento/Erro
            if (vm.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (vm.errorMessage != null) {
              return Center(child: Text(vm.errorMessage!, style: AppTypography.bodyText.copyWith(color: AppColors.error)));
            }

            final item = vm.item;
            final reviews = item?.recentReviews ?? []; // Pega a lista de reviews

            if (item != null) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Informações Principais do Item ---
                    Text(item.title, style: AppTypography.headline1),
                    const SizedBox(height: 8),
                    Text('Tipo: ${item.type} | Lançamento: ${item.releaseDate.year}', style: AppTypography.bodyText),
                    const SizedBox(height: 16),
                    
                    // Nota Média
                    Text(
                      'Avaliação Média: ${item.averageRating.toStringAsFixed(1)} (${item.totalReviews})', 
                      style: AppTypography.title.copyWith(color: AppColors.primary)
                    ),
                    const SizedBox(height: 24),
                    Text(item.description, style: AppTypography.bodyText),
                    const SizedBox(height: 40),

                    // --- Seção de Reviews ---
                    Text(
                      'Últimas Avaliações', 
                      style: AppTypography.title
                    ),
                    const SizedBox(height: 16),

                    // 💡 NOVO: Lista de Reviews usando ListView.builder aninhado
                    if (reviews.isEmpty)
                      Text('Nenhuma avaliação encontrada.', style: AppTypography.caption.copyWith(color: AppColors.textLight))
                    else
                      ListView.builder(
                        // Crucial para aninhar ListView dentro de SingleChildScrollView
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true, 
                        itemCount: reviews.length,
                        itemBuilder: (context, index) {
                          // Usa o componente ReviewTile criado
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