import 'dart:convert';
import 'package:http/http.dart' as http;

// Importa modelos e o cliente HTTP
import '../models/review_model.dart'; 
import 'api_client.dart';

class ReviewService {
  final ApiClient _apiClient;

  // Injeção de Dependência
  ReviewService(this._apiClient);

  // Endpoint base
  static const String _endpoint = '/reviews'; 

  // Criar uma Nova Review (POST /reviews)
  // A API Node.js extrai o userId do JWT, então NÃO precisa passá-lo no body.

  Future<ReviewModel> createReview({
    required String itemId, 
    required int rating, 
    required String textContent
  }) async {
    
    final Map<String, dynamic> body = {
      'itemId': itemId,
      'rating': rating,
      'text': textContent,
      // userId NÃO é necessário aqui, pois a API pega do token!
    };

    // Chamada PROTEGIDA: requer JWT no header.
    final http.Response response = await _apiClient.post(_endpoint, body: body, requiresAuth: true);

    if (response.statusCode == 201) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return ReviewModel.fromJson(jsonResponse);
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      throw Exception('Não autorizado. Faça login novamente.');
    } else if (response.statusCode == 400) {
      throw Exception('Dados inválidos. Verifique a nota e o ID do item.');
    } else {
      throw Exception('Falha ao criar review. Código: ${response.statusCode}');
    }
  }

  // Atualizar uma Review (PUT /reviews/:id)
  // A API Node.js verifica se o dono do JWT é o autor da review.

  Future<ReviewModel> updateReview(String reviewId, {int? rating, String? textContent}) async {
    final String endpoint = '$_endpoint/$reviewId';
    
    final Map<String, dynamic> body = {};
    if (rating != null) body['rating'] = rating;
    if (textContent != null) body['text'] = textContent;

    // Chamada PROTEGIDA: requer JWT no header.
    final http.Response response = await _apiClient.put(endpoint, body: body, requiresAuth: true);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return ReviewModel.fromJson(jsonResponse);
    } else if (response.statusCode == 403) {
      throw Exception('Você só pode editar suas próprias avaliações.');
    } else if (response.statusCode == 404) {
      throw Exception('Review não encontrada.');
    } else {
      throw Exception('Falha ao atualizar review. Código: ${response.statusCode}');
    }
  }

  // Deletar uma Review (DELETE /reviews/:id)
  
  Future<void> deleteReview(String reviewId) async {
    final String endpoint = '$_endpoint/$reviewId';

    // Chamada PROTEGIDA: requer JWT no header.
    final http.Response response = await _apiClient.delete(endpoint, requiresAuth: true);

    if (response.statusCode == 200) {
      return; // Sucesso na deleção
    } else if (response.statusCode == 403) {
      throw Exception('Você só pode deletar suas próprias avaliações.');
    } else if (response.statusCode == 404) {
      throw Exception('Review não encontrada.');
    } else {
      throw Exception('Falha ao deletar review. Código: ${response.statusCode}');
    }
  }
}