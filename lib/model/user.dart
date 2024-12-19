class User {
  final int? id;
  final String? email;
  final String? name;
  final String? password;
  final String? role;
  final String? selectedTeacher;

  User({
    this.id,
    required this.name,
    required this.password,
    required this.email,
    required this.role,
    required this.selectedTeacher,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? 0,
      name: map['name'] ?? "",
      password: map['password'] ?? "",
      email: map['email'] ?? "",
      role: map['role'] ?? "",
      selectedTeacher: map['selectedTeacher'] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      "role": role,
      "selectedTeacher": selectedTeacher,
    };
  }
}
