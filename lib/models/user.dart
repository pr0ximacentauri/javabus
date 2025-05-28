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
      id: json['id'],
      username: json['username'],
      fullName: json['fullName'],
      email: json['email'],
      password: json['password'],
      roleId: json['roleId'] is int
          ? json['roleId']
          : int.tryParse(json['roleId'].toString()),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'fullName': fullName,
    'email': email,
    'password': password,
    'roleId': roleId,
  };
}