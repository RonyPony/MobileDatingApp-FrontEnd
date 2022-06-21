import 'package:flutter/material.dart';

import '../models/user.dart';
import '../services/match_service.dart';

class MatchProvider with ChangeNotifier {
  final MatchService _service;

  MatchProvider(this._service);

  Future<User>getPossibleMatch(int userId)async{
    var response = await _service.getPossibleMatch(userId);
    return response;
  }
}