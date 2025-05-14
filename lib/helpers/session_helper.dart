import 'package:shared_preferences/shared_preferences.dart';

class SessionHelper {
  static const _tokenKey = 'jwt_token';
  static const _staySignedKey = 'stay_signed';

  static Future<void> saveToken(String token, bool staySigned) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setBool(_staySignedKey, staySigned);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey) != null &&
        prefs.getBool(_staySignedKey) == true;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_staySignedKey);
  }
}
