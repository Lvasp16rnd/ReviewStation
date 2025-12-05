// user_model.dart

class UserModel {
  // --- Identificadores ---
  final String id;
  final String email;
  
  // --- Dados do Perfil ---
  final String fullName;
  final int? age;
  
  // Adicionei um campo opcional para avatar/URL, 
  // caso queira usá-lo futuramente para imagens de perfil.
  final String? avatarUrl; 

  UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    this.age,
    this.avatarUrl,
  });

  // Método de Fábrica para construir o modelo a partir do JSON da API
  factory UserModel.fromJson(Map<String, dynamic> json) {
    
    // DECLARAÇÃO E LÓGICA DE FALLBACK DE NOME (Deve ser a primeira linha executada)
    // Lê 'fullName' ou usa 'name' (do Prisma) como fallback, ou 'Nome Indisponível'.
    final nameValue = (json['fullName'] as String?) ?? (json['name'] as String?) ?? 'Nome Indisponível';
    
    // Leitura segura de outros campos
    final ageValue = json['age'];
    
    return UserModel(
        id: json['id'] as String,
        email: (json['email'] as String?) ?? 'e-mail não disponível', 
        
        // Usa a variável local 'nameValue' que acabamos de declarar
        fullName: nameValue, 
        
        // Mapeamento de idade segura
        age: ageValue is int ? ageValue : null,
        avatarUrl: json['avatarUrl'] as String?, 
    );
}

  // Opcional: Método para serializar (transformar em JSON) para enviar
  // dados de volta para a API (ex: PUT /users/:id)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': fullName, 
      'age': age,
      'avatarUrl': avatarUrl,
    };
  }
}