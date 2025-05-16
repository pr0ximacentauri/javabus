import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:javabus/const/api_url.dart' as url;
import 'package:javabus/models/user.dart';

class AuthService{
  final String apiUrl = '${url.baseUrl}/Auth';

  Future<Map<String, dynamic>> register(String username, String fullName, String email, String password, int roleId) async{
    final response = await http.post(Uri.parse('$apiUrl/register'), 
      headers: {'Content-Type': 'application/json'},
      body: {
      'username': username, 
      'full_name': fullName,
      'email': email,
      'password': password,
      'roleId': roleId = 2
      }
    );

    try{
      if(response.statusCode == 200){
        final data = jsonDecode(response.body);
        return{
          'token': data['token'],
          'user': User.fromJson(data['user']),
        }; 
      }else{
        throw Exception(jsonDecode(response.body)['message']);
      }
    }catch(e){
      throw Exception(e.toString());
    }
  }

  Future<String> login(String username, String password) async{
    final response = await http.post(Uri.parse('$apiUrl/login'), 
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password})
    );

    try{
      if(response.statusCode == 200){
        final data = jsonDecode(response.body);
        final token = data['token'];
        if (token == null) throw Exception('Token tidak ditemukan');
        return token; 
      }else{
        throw Exception(jsonDecode(response.body)['message']) ?? 'Login gagal';
      }
    }catch(e){
      throw Exception(e.toString());
    }
  }

  Future<bool> updateUser(User user) async{
    final response = await http.put(Uri.parse('$apiUrl/update/${user.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Error: ${response.body}');
      return false;
    }
  }

  Future<bool> updatePassword({required int userId, required String oldPassword, required String newPassword}) async{
    final response = await http.put(Uri.parse('$apiUrl/update-password/$userId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'oldPassword': oldPassword, 'newPassword': newPassword}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Error: ${response.body}');
      return false;
    }
  }
}