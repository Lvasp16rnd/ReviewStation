import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../resources/shared/styles/typography.dart';
import 'home_viewmodel.dart';
// import '../../../components/item_card_view.dart'; // Futuro componente de item

class HomeView extends StatelessWidget {
  final HomeViewModel viewModel;

  const HomeView({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: viewModel,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Catálogo ReviewStation"),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: viewModel.logoutTapped,
            ),
          ],
        ),
        body: Consumer<HomeViewModel>(
          builder: (context, vm, child) {
            
            // Estado de Carregamento
            if (vm.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            
            // Estado de Erro
            if (vm.errorMessage != null) {
              return Center(child: Text("Erro: ${vm.errorMessage}", style: AppTypography.bodyText));
            }

            // Lista Vazia
            if (vm.items.isEmpty) {
              return Center(child: Text("Nenhum item no catálogo.", style: AppTypography.bodyText));
            }
            
            // Lista de Itens (GridView ou ListView)
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: vm.items.length,
              itemBuilder: (context, index) {
                final item = vm.items[index];
                
                // Usar o ItemCardView (seu componente)
                return ListTile(
                  title: Text(item.title, style: AppTypography.title),
                  subtitle: Text("${item.type} | Nota: ${item.averageRating}", style: AppTypography.caption),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => vm.itemTapped(item.id), // Chama a intenção de navegação
                );
              },
            );
          },
        ),
      ),
    );
  }
}