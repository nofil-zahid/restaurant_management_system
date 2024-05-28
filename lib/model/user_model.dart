class User {
  String name;
  String password;
  String role;

  User({required this.name, required this.password, required this.role});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      password: json['password'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'password': password,
      'role': role,
    };
  }
}
