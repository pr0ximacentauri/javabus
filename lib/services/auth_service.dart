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
        final body = jsonDecode(response.body);
        return{
          'token': body['token'],
          'user': User.fromJson(body['user']),
        }; 
      }else{
        throw Exception(jsonDecode(response.body)['message']);
      }
    }catch(e){
      throw Exception(e.toString());
    }
  }

  Future<Map<String, dynamic>> login(String username, String password) async{
    final response = await http.post(Uri.parse('$apiUrl/login'), 
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password})
    );

    try{
      if(response.statusCode == 200){
        final body = jsonDecode(response.body);
        return{
          'token': body['token'],
          'user': User.fromJson(body['user']),
        }; 
      }else{
        throw Exception(jsonDecode(response.body)['message']);
      }
    }catch(e){
      throw Exception(e.toString());
    }
  }
}