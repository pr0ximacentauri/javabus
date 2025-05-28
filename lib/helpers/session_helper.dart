import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:javabus/models/user.dart';

class SessionHelper {
  static const _tokenKey = 'jwt_token';
  static const _staySignedKey = 'stay_signed';
  static const _userKey = 'user_data';

  static Future<void> saveUserSession(String token, User user, bool staySigned) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setBool(_staySignedKey, staySigned);
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson == null) return null;

    try {
      final map = jsonDecode(userJson);
      return User.fromJson(map);
    } catch (e) {
      return null;
    }
  }

  static Future<void> updateUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }



  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey) != null;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_staySignedKey);
    await prefs.remove(_userKey);
  }
}
