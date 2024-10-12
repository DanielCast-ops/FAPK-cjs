class User {
  final int? id;
  final String username;
  String password;

  User({
    this.id,
    required this.username,
    required this.password,
  });

  // Convierte un User a un Map. Útil para insertar en la base de datos.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
    };
  }

  // Crea un User desde un Map. Útil cuando se lee de la base de datos.
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      password: map['password'],
    );
  }

  // Crea una copia del usuario con campos actualizados
  User copyWith({
    int? id,
    String? username,
    String? password,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }

  @override
  String toString() {
    return 'User{id: $id, username: $username}';
  }
}