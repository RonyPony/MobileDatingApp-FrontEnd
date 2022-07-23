import 'package:inlove/models/user.dart';

import '../models/userMatch.dart';

abstract class MatchContract {
  Future<User>getPossibleMatch(int userId);
  Future<bool>createMatch(int originUserId,int destinUserId);
  Future<List<UserMatch>>getUserMatches(int userId);
}