import 'package:flutter/material.dart';
import 'package:inlove/models/userLogin.dart';
import 'package:inlove/services/authService.dart';

import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  AuthService _authService;

  AuthProvider(this._authService);

  Future<bool> userEmailExists(String userEmail) async {
    final bool response = await _authService.userExists(userEmail);
    return response;
  }
  Future<bool>performLogin(Login userLogin) async {
    final bool response = await _authService.performLogin(userLogin);
    return response;
  }
}