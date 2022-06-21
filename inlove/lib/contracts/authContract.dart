// ignore: file_names
import '../models/user.dart';
import '../models/userLogin.dart';

abstract class AuthContract {
  Future<bool>userExists(String userEmail);
  Future<User>findUserByEmail(String userEmail);
  Future<bool>performLogin(Login userLogin);
  Future<bool>saveLocalUserInfo(User usuario);
  Future<User> readLocalUserInfo();
}