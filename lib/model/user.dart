class User {
  final int? id;
  final String? email;
  final String? name;
  final String? password;
  final String? registerAs;

  User({
    this.id,
    required this.name,
    required this.password,
    required this.email,
    required this.registerAs,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? 0,
      name: map['name'] ?? "",
      password: map['password'] ?? "",
      email: map['email'] ?? "",
      registerAs: map['registerAs'] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      "registerAs": registerAs,
    };
  }
}
