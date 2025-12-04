// review_model.dart
import 'user_model.dart';
// Importa o modelo de usuário, que será aninhado nesta review.

class ReviewModel {
  // --- Identificadores da Review ---
  final String id;
  final String itemId; // ID do Item que está sendo avaliado
  final String userId; // ID do Usuário que fez a avaliação

  // --- Conteúdo da Review ---
  final String? textContent; // O texto da avaliação (pode ser opcional)
  final double rating;        // A nota dada (ex: 4.5)
  final DateTime createdAt;   // Timestamp de criação

  // --- Relacionamento Aninhado ---
  // A API pode retornar os dados básicos do usuário que escreveu a review.
  final UserModel? author; 

  ReviewModel({
    required this.id,
    required this.itemId,
    required this.userId,
    required this.rating,
    required this.createdAt,
    this.textContent,
    this.author,
  });

  // Método de Fábrica para construir o modelo a partir do JSON da API
  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    // Tenta converter o campo 'author' para UserModel se estiver presente.
    final authorJson = json['author'];
    final UserModel? authorModel = authorJson != null
        ? UserModel.fromJson(authorJson)
        : null;

    return ReviewModel(
      id: json['id'] as String,
      itemId: json['itemId'] as String,
      userId: json['userId'] as String,
      
      // Garante que o rating seja um double
      rating: (json['rating'] as num).toDouble(),
      
      // Converte a string de timestamp para objeto DateTime
      createdAt: DateTime.parse(json['createdAt'] as String),

      // Campos opcionais
      textContent: json['textContent'] as String?,
      author: authorModel,
    );
  }
}

