import 'package:inlove/models/user.dart';

abstract class MatchContract {
  Future<User>getPossibleMatch(int userId);
}