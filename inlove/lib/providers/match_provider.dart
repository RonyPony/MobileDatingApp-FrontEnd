import 'package:flutter/material.dart';

import '../models/user.dart';
import '../models/userMatch.dart';
import '../services/match_service.dart';

class MatchProvider with ChangeNotifier {
  final MatchService _service;

  MatchProvider(this._service);

  Future<User>getPossibleMatch(int userId)async{
    var response = await _service.getPossibleMatch(userId);
    return response;
  }

  Future<bool>createMatch(int originUserId,int destinUserId) async {
    var response = await _service.createMatch(originUserId, destinUserId);
    return response;
  }
  Future<List<UserMatch>> getUserMatches(int userId) async {
    var response  = await _service.getUserMatches(userId);
    return response;
  }
}