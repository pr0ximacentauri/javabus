class User {
  final int id;
  final String username;
  final String fullName;
  final String email;
  final String password;
  final int roleId;
  
  User({
    required this.id,
    required this.username,
    required this.fullName,
    required this.email,
    required this.password,
    required this.roleId
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id_user'],
      username: json['username'],
      fullName: json['full_name'],
      email: json['email'],
      password: json['password'],
      roleId: int.parse(json['fk_role'] ?? 2)
    );
  }
}