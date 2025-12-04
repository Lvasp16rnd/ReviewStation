import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:reviewstation_app/scenes/write_review/wirte_review_viewmodel.dart';


class WriteReviewView extends StatelessWidget {
  final WriteReviewViewModel viewModel;

  const WriteReviewView({
    required this.viewModel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Usamos ChangeNotifierProvider.value para injetar o ViewModel
    return ChangeNotifierProvider.value(
      value: viewModel,
      // Usamos Consumer para reconstruir a view quando o ViewModel muda (e.g., loading, erro)
      child: Consumer<WriteReviewViewModel>(
        builder: (context, vm, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Avaliar ${vm.itemName}'),
            ),
            body: const _ReviewForm(),
          );
        },
      ),
    );
  }
}

// -------------------------------------------------------------------
// Widget Interno: O Formulário
// -------------------------------------------------------------------

class _ReviewForm extends StatefulWidget {
  const _ReviewForm();

  @override
  State<_ReviewForm> createState() => __ReviewFormState();
}

class __ReviewFormState extends State<_ReviewForm> {
  // Estado interno para gerenciar os inputs
  int _rating = 0;
  final TextEditingController _textController = TextEditingController();

  // Função para lidar com a submissão
  void _submitReview(BuildContext context) async {
    final viewModel = Provider.of<WriteReviewViewModel>(context, listen: false);

    // Se já estiver carregando, ignorar submissão
    if (viewModel.isLoading) return;

    // Chamar a lógica de submissão do ViewModel
    final success = await viewModel.handleSubmitReview(
      rating: _rating,
      textContent: _textController.text.trim(),
    );

    // Se falhar, mostrar o erro
    if (!success && viewModel.errorMessage != null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(viewModel.errorMessage!)),
        );
      }
    }
    // Se for sucesso, o ViewModel chama o `coordinator.pop()`
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<WriteReviewViewModel>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // --- Seletor de Rating (Estrelas) ---
          const Text(
            'Sua Nota:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          _RatingSelector(
            currentRating: _rating,
            onRatingSelected: (rating) {
              setState(() {
                _rating = rating;
              });
            },
          ),
          const SizedBox(height: 24.0),

          // --- Campo de Texto da Review ---
          const Text(
            'Seu Comentário:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          TextField(
            controller: _textController,
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: 'O que achou deste produto?',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.all(12.0),
            ),
          ),
          const SizedBox(height: 32.0),

          // --- Botão de Submissão ---
          ElevatedButton(
            onPressed: viewModel.isLoading 
                ? null 
                : () => _submitReview(context),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14.0),
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            ),
            child: viewModel.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  )
                : const Text(
                    'Enviar Avaliação',
                    style: TextStyle(fontSize: 18),
                  ),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------------
// Widget Reutilizável: Seletor de Estrelas
// -------------------------------------------------------------------

class _RatingSelector extends StatelessWidget {
  final int currentRating;
  final ValueChanged<int> onRatingSelected;

  const _RatingSelector({
    required this.currentRating,
    required this.onRatingSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final rating = index + 1;
        return IconButton(
          icon: Icon(
            rating <= currentRating ? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: 40.0,
          ),
          onPressed: () => onRatingSelected(rating),
        );
      }),
    );
  }
}