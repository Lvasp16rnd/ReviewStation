// item_model.dart
import 'review_model.dart'; 
// ...
class ItemModel {
  // --- Campos Principais do Item ---
  final String id;
  final String title;
  final String description;
  final String type; // Ex: 'Movie', 'Book', 'Game'
  final DateTime releaseDate;

  // --- Campos de Agregação da Review ---
  final double averageRating; // A média calculada pela API
  final int totalReviews;     // O número total de reviews

  // --- Relacionamento (Reviews) ---
  // A API pode retornar uma lista de Reviews recentes junto com o Item.
  // Usamos a lista de ReviewModel aqui.
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
  });

  // Método de Fábrica para construir o modelo a partir do JSON da API
  factory ItemModel.fromJson(Map<String, dynamic> json) {
    // Tratamento da lista de reviews: garante que ela seja populada corretamente
    // Se 'recentReviews' não vier, usa uma lista vazia.
    final List<dynamic>? reviewsJson = json['recentReviews'];
    final List<ReviewModel> reviews = reviewsJson != null
        ? reviewsJson.map((r) => ReviewModel.fromJson(r)).toList()
        : [];
        
    // A API Node.js/Prisma geralmente retorna IDs como Strings.
    return ItemModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: json['type'] as String,
      
      // Converte a string de data (ISO 8601) para objeto DateTime
      releaseDate: DateTime.parse(json['releaseDate'] as String), 
      
      // A média pode vir como int, double ou string; garante que seja double
      averageRating: (json['averageRating'] as num).toDouble(),
      totalReviews: json['totalReviews'] as int,
      recentReviews: reviews,
    );
  }
}

