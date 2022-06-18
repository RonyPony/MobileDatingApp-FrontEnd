import 'package:flutter/material.dart';
import 'package:inlove/models/user_login.dart';
import 'package:inlove/services/auth_service.dart';

import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService;

  AuthProvider(this._authService);

  Future<bool> userEmailExists(String userEmail) async {
    final bool response = await _authService.userExists(userEmail);
    return response;
  }
  Future<bool>performLogin(Login userLogin) async {
    final bool response = await _authService.performLogin(userLogin);
    return response;
  }
  Future<User>readLocalUserInfo() async {
    final User response = await _authService.readLocalUserInfo();
    return response;
  }
}