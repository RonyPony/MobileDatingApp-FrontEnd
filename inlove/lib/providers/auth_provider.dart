import 'package:flutter/material.dart';
import 'package:inlove/models/sexual_orientations.dart';
import 'package:inlove/models/user_login.dart';
import 'package:inlove/services/auth_service.dart';

import '../models/user.dart';
import '../models/user_register.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService;

  AuthProvider(this._authService);

  Future<bool> userEmailExists(String userEmail) async {
    final bool response = await _authService.userExists(userEmail);
    return response;
  }

  Future<bool> performLogin(Login userLogin) async {
    final bool response = await _authService.performLogin(userLogin);
    return response;
  }

  Future<User> readLocalUserInfo() async {
    final User response = await _authService.readLocalUserInfo();
    return response;
  }

  Future<bool> updateUserInfo(User user) async {
    final bool response = await _authService.updateUserInfo(user);
    return response;
  }

  Future<bool> registerUser(Register usuario) async {
    final bool response = await _authService.registerUser(usuario);
    return response;
  }

  Future<bool> saveLocalUserInfoUser(User user) async {
    final bool response = await _authService.saveLocalUserInfo(user);
    return response;
  }

  Future<List<SexualOrientation>> getAllSexualOrientations() async {
    final List<SexualOrientation> response = await _authService.getAllSexes();
    return response;
  }

  Future<SexualOrientation> getSexualOrientationByName(String sexName) async {
    final SexualOrientation response =
        await _authService.getSexualOrientationByName(sexName);
    return response;
  }

  Future<SexualOrientation> getSexualOrientationById(int id) async {
    final SexualOrientation response =
        await _authService.getSexualOrientationById(id);
    return response;
  }

  Future<User> findUserById(int userId) async {
    var response =  await _authService.findUserById(userId);
    return response;
  }
}
