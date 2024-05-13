// models/role.dart
class Role {
  final int roleId;
  final String roleDescription;

  Role({
    required this.roleId,
    required this.roleDescription,
  });

  Map<String, dynamic> toMap() {
    return {
      'role_id': roleId,
      'role_des': roleDescription,
    };
  }

  factory Role.fromMap(Map<String, dynamic> map) {
    return Role(
      roleId: map['role_id'],
      roleDescription: map['role_des'],
    );
  }
}
