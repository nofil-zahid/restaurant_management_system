// models/user.dart
class User {
  final int userId;
  final String userName;
  final int roleId;

  User({
    required this.userId,
    required this.userName,
    required this.roleId,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'user_name': userName,
      'role_id': roleId,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      userId: map['user_id'],
      userName: map['user_name'],
      roleId: map['role_id'],
    );
  }
}
