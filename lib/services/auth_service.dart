import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:javabus/const/api_url.dart' as url;
import 'package:javabus/helpers/session_helper.dart';
import 'package:javabus/models/user.dart';

class AuthService{
  final String apiUrl = '${url.baseUrl}/Auth';

  Future<Map<String, dynamic>?> register(String username, String fullName, String email, String password, int roleId) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'Username': username,
          'FullName': fullName,
          'Email': email,
          'Password': password,
          'RoleId': roleId
        }),
      );

      // print("Register response: ${response.statusCode}");
      // print("Register body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return {'message': data['message'] ?? 'Pendaftaran berhasil'};
      } else {
        print('Register gagal: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Register error: $e');
      return null;
    }
  }


  Future<String?> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];
        if (token == null) return null;
        return token;
      } else {
        print('Login gagal: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  Future<bool> updateAccount({
    required int userId,
    required String username,
    required String fullName,
    required String email,
    String? newPassword,
    String? imageUrl
  }) async {
    final url = Uri.parse('$apiUrl/update-account/$userId');

    final body = {
      'username': username,
      'fullName': fullName,
      'email': email,
      'newPassword': newPassword ?? '',
      'imageUrl': imageUrl ?? '',
    };

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer ${await SessionHelper.getToken()}'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      // print('Update akun gagal (${response.statusCode})');
      // print('Body: ${response.body}');
      return false;
    }
  }

  Future<User?> getById(int id) async {
    final response = await http.get(Uri.parse('$apiUrl/$id'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return User.fromJson(data);
    } else {
      return null;
    }
  }

}