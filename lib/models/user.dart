class User {
  final int id;
  final String username;
  final String fullName;
  final String email;
  final String password;
  final String? imageUrl;
  final int roleId;
  
  User({
    required this.id,
    required this.username,
    required this.fullName,
    required this.email,
    required this.password,
    this.imageUrl,
    required this.roleId
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      fullName: json['fullName'],
      email: json['email'],
      password: json['password'],
      imageUrl: json['imageUrl'],
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
    'imageUrl': imageUrl,
    'roleId': roleId,
  };
}