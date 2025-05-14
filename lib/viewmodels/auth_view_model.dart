import 'package:flutter/material.dart';
import 'package:javabus/helpers/session_helper.dart';
import 'package:javabus/models/user.dart';
import 'package:javabus/services/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;
  User? currentUser;

  Future<bool> login(String username, String password, bool staySigned) async {
    isLoading = true;
    notifyListeners();
    try {
      final result = await AuthService().login(username, password);
      final token = result['token'];
      final user = result['user'];

      await SessionHelper.saveToken(token, staySigned);
      currentUser = user;
      errorMessage = null;
      return true;
    } catch (e) {
      errorMessage = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await SessionHelper.logout();
    currentUser = null;
    notifyListeners();
  }
}
