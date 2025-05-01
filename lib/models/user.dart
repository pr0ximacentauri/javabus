class User {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String password;
  
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id_user'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      password: json['password'],
    );
  }
}