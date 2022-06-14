import '../models/userLogin.dart';

abstract class AuthContract {
  Future<bool>userExists(String userEmail);
  Future<bool>performLogin(Login userLogin);
}