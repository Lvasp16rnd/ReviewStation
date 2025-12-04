// item_model.dart
import 'review_model.dart'; 
import 'dart:convert';
import 'dart:core'; // Importado implicitamente, mas para clareza

class ItemModel {
  // ... Campos Principais
  final String id;
  final String title;
  final String description;
  final String type; 
  final DateTime releaseDate;
  final String? posterUrl;

  // ... Campos de Agregação
  final double averageRating; 
  final int totalReviews;     

  // --- Relacionamento (Reviews) ---
  final List<ReviewModel> recentReviews; 

  ItemModel({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.releaseDate,
    required this.averageRating,
    required this.totalReviews,
    required this.recentReviews,
    this.posterUrl,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    
    final descriptionValue = (json['description'] as String?) ?? '';
    
    final rawYear = json['releaseYear'] as int?; 
    final DateTime releaseDateValue = rawYear != null
        ? DateTime.utc(rawYear) // Agora sabemos que é um int não-nulo
        : DateTime(1900); 

    // 🔑 CORREÇÃO CRÍTICA: Lendo a chave 'reviews' do JSON da API
    final List<dynamic>? reviewsJson = json['reviews']; // <<-- A CHAVE CORRETA

    final List<ReviewModel> reviews = reviewsJson != null
        ? reviewsJson.map((r) {
            final reviewMap = Map<String, dynamic>.from(r as Map);
            reviewMap['itemId'] = json['id']; // Injeta o ID do Item
            
            return ReviewModel.fromJson(reviewMap);
        }).toList()
        : [];
        
    return ItemModel(
        id: json['id'] as String,
        title: json['title'] as String,
        posterUrl: json['posterUrl'] as String?,
        description: descriptionValue, 
        type: json['type'] as String,
        releaseDate: releaseDateValue, 
        averageRating: (json['averageRating'] as num? ?? 0.0).toDouble(), 
        totalReviews: (json['totalReviews'] as int? ?? 0),
        recentReviews: reviews,
    );
  }
}