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
  // 1. Listar Catálogo (GET /item) - AGORA COM DIAGNÓSTICO
  // -------------------------------------------------------------------

  Future<List<ItemModel>> fetchItemList({String? type, int? year}) async {
    
    final Map<String, dynamic> queryParams = {};
    if (type != null) {
      queryParams['type'] = type;
    }
    if (year != null) {
      queryParams['releaseYear'] = year;
    }

    try {
      final http.Response response = await _apiClient.get(_endpoint, queryParams: queryParams);

      // 🚨 DIAGNÓSTICO 1: Loga o status e o corpo recebido
      print('--- Diagnóstico GET /item ---');
      print('Status Code: ${response.statusCode}');
      print('Response Body Preview: ${response.body.substring(0, 50)}...');
      print('-----------------------------');

      if (response.statusCode == 200) {
        // Tenta decodificar a lista
        final List<dynamic> jsonList = jsonDecode(response.body); 
        
        // Mapeia a lista de JSONs para uma lista de ItemModel
        return jsonList.map((json) => ItemModel.fromJson(json)).toList();
      } else {
        // Lança exceção para qualquer status que não seja 200
        throw Exception('Falha ao buscar itens. Status: ${response.statusCode}');
      }
    } catch (e) {
      // 🚨 DIAGNÓSTICO 2: Captura erros de parsing JSON ou de rede
      print('Erro de execução em fetchItemList: $e');
      throw Exception('Não foi possível processar a lista de itens. Detalhes: ${e.toString()}');
    }
  }

  // -------------------------------------------------------------------
  // 2. Detalhes do Item (GET /item/:id) - Mantido
  // -------------------------------------------------------------------

  Future<ItemModel> fetchItemDetails(String itemId) async {
    final String endpoint = '$_endpoint/$itemId';

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
