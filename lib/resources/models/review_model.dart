class ReviewModel {
  // --- Identificadores da Review ---
  final String id;
  final String? itemId; 
  final String? userId; 

  // --- Conteúdo da Review ---
  final String? textContent; 
  final double rating;        
  final DateTime createdAt;   

  final String? userName; 

  ReviewModel({
    required this.id,
    this.itemId, 
    this.userId,
    required this.rating,
    required this.createdAt,
    this.textContent,
    this.userName, 
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {


    return ReviewModel(
      id: json['id'] as String,
      
      // Lendo o campo com segurança (opcional)
      itemId: json['itemId'] as String?, 
      
      // UserId não é enviado pela API, mas podemos tentar ler o id do usuário se vier
      userId: json['userId'] as String?, 
      
      rating: (json['rating'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),

      // Mapeamento correto do campo de texto da API
      textContent: json['text'] as String?, 
      
      // CAMPO CORRIGIDO: Lendo o campo plano 'userName'
      userName: json['userName'] as String?, 
    );
  }
}