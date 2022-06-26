import 'package:inlove/models/user.dart';

abstract class MatchContract {
  Future<User>getPossibleMatch(int userId);
  Future<bool>createMatch(int originUserId,int destinUserId);
}