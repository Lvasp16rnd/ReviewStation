// user_model.dart

class UserModel {
  // --- Identificadores ---
  final String id;
  final String email;
  
  // --- Dados do Perfil ---
  final String fullName;
  final int? age;
  
  // ⚠️ Nota: Adicionei um campo opcional para avatar/URL, 
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
    // 💡 No MVVM, é bom ter um campo que represente o nome completo
    // mesmo que a API use 'name' (que mapeamos para 'fullName' aqui).
    
    // O campo 'age' é opcional (nullable), então verificamos o tipo.
    final ageValue = json['age'];
    
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['name'] as String, 
      
      // Mapeia o campo opcional 'age' (pode ser int ou null)
      age: ageValue is int ? ageValue : null,
      
      // Exemplo de mapeamento de um campo de metadados opcional
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