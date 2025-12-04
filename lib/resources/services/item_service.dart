// Camada responsável por buscar e formatar os dados do catálogo
// da API (ex: GET /item e GET /item/:id), incluindo o cálculo 
// das médias de rating.

import 'dart:convert';
import 'package:http/http.dart' as http;

// Importa os modelos de dados
import '../models/item_model.dart'; 

// Importa o cliente HTTP base
import 'api_client.dart';

class ItemService {
  final ApiClient _apiClient;

  // Injeção de Dependência
  ItemService(this._apiClient);

  // Endpoint base
  static const String _endpoint = '/item'; 

  // -------------------------------------------------------------------
  // 1. Listar Catálogo (GET /item)
  // -------------------------------------------------------------------

  Future<List<ItemModel>> fetchItemList({String? type, int? year}) async {
    
    // Constrói os Query Parameters (ex: ?type=MOVIE)
    final Map<String, dynamic> queryParams = {};
    if (type != null) {
      queryParams['type'] = type;
    }
    if (year != null) {
      queryParams['releaseYear'] = year;
    }

    // Nota: A rota GET /item não é protegida por JWT em sua API atual.
    final http.Response response = await _apiClient.get(_endpoint, queryParams: queryParams);

    if (response.statusCode == 200) {
      // Converte a string JSON para uma lista dinâmica
      final List<dynamic> jsonList = jsonDecode(response.body); 
      
      // Mapeia a lista de JSONs para uma lista de ItemModel
      return jsonList.map((json) => ItemModel.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar a lista de itens. Código: ${response.statusCode}');
    }
  }

  // -------------------------------------------------------------------
  // 2. Detalhes do Item (GET /item/:id)
  // -------------------------------------------------------------------

  Future<ItemModel> fetchItemDetails(String itemId) async {
    final String endpoint = '$_endpoint/$itemId';

    // Nota: A rota GET /item/:id também não é protegida.
    final http.Response response = await _apiClient.get(endpoint, requiresAuth: false);

    if (response.statusCode == 200) {
      // Convertendo o JSON de resposta para o ItemModel
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return ItemModel.fromJson(jsonResponse);
    } else if (response.statusCode == 404) {
      throw Exception('Item não encontrado.');
    } else {
      throw Exception('Falha ao carregar detalhes do item. Código: ${response.statusCode}');
    }
  }

  // -------------------------------------------------------------------
  // 3. (Implementar***) Gerenciamento de Item - Exige JWT
  // -------------------------------------------------------------------

  // Future<void> updateItem(String itemId, Map<String, dynamic> data, String token) async {
  //   // Este método exigiria que o ApiClient fosse capaz de adicionar o Header JWT!
  //   final String endpoint = '$_endpoint/$itemId';
  //   // Simulação de chamada: await _apiClient.put(endpoint, body: data, token: token);
  //   // ...
  // }
}