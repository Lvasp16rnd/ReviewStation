// review_model.dart
import 'user_model.dart';
import 'dart:core'; // Importado implicitamente, mas para clareza

class ReviewModel {
  // --- Identificadores da Review ---
  final String id;
  final String? itemId; //
  final String? userId; //

  // --- Conteúdo da Review ---
  final String? textContent; 
  final double rating;        
  final DateTime createdAt;   

  // --- Relacionamento Aninhado ---
  final UserModel? author; 

  ReviewModel({
    required this.id,
    this.itemId, // 🔑 Opcional no construtor
    this.userId, // 🔑 Opcional no construtor
    required this.rating,
    required this.createdAt,
    this.textContent,
    this.author,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    
    // 1. Mapear o Autor (Correto)
    final authorJson = json['author'];
    final UserModel? authorModel = authorJson != null
        ? UserModel.fromJson(authorJson as Map<String, dynamic>)
        : null;

    return ReviewModel(
      id: json['id'] as String,
      
      // 🔑 Agora itemId é lido da chave injetada (opcional)
      itemId: json['itemId'] as String?, 
      userId: authorModel?.id as String?, 
      
      rating: (json['rating'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),

      // ✅ CORREÇÃO CRÍTICA: Ler apenas a chave 'text' da API
      textContent: json['text'] as String?, 
      author: authorModel,
    );
  }
}