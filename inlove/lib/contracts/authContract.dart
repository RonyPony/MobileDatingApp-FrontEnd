abstract class AuthContract {
  Future<bool>userExists();
  Future<bool>performLogin();
}