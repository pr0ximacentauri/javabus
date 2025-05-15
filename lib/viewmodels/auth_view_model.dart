import 'package:flutter/material.dart';
import 'package:javabus/models/user.dart';
import 'package:javabus/services/auth_service.dart';
import 'package:javabus/helpers/session_helper.dart';
import 'package:jwt_decode/jwt_decode.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  User? _user;
  User? get user => _user;

  Future<bool> login(String username, String password, bool staySigned) async {
    _isLoading = true;
    notifyListeners();

    try {
      final token = await _authService.login(username, password);
      Map<String, dynamic> payload = Jwt.parseJwt(token);
      final user = User(
        id: int.parse(payload['sub']),
        username: username,
        fullName: payload['name'],
        email: payload['email'],
        password: '', 
        roleId: _mapRoleToId(payload['role']),
      );
      
      _user = user;

      await SessionHelper.saveUserSession(token, user, staySigned);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> logout() async {
    _user = null;
    await SessionHelper.logout();
    notifyListeners();
  }

  Future<void> loadUserFromSession() async {
    final isLogged = await SessionHelper.isLoggedIn();
    if (isLogged) {
      _user = await SessionHelper.getUser();
      notifyListeners();
    }
  }


  int _mapRoleToId(String? role) {
  switch (role) {
    case 'admin':
      return 1;
    case 'user':
      return 2;
    default:
      return 2;
  }
}
}
