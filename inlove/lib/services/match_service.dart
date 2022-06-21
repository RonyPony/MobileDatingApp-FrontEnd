import 'package:dio/dio.dart';
import 'package:inlove/contracts/match_contract.dart';
import 'package:inlove/models/user.dart';

import '../constant.dart';

class MatchService implements MatchContract {
  @override
  Future<User> getPossibleMatch(int userId) async {
    User foundUser = User();
    try {
      var resp = await Dio().get(
          serverurl+'api/matches/getPossibleMatch/$userId');
      if(resp.statusCode == 200){
        foundUser = User.fromJson(resp.data);
        return foundUser;
      }

      if(resp.statusCode=="404"){
        print("User Not Found");
      }
      return foundUser;
    } 
    on DioError catch (e) {
      //http error(statusCode not 20x) will be catched here.
      print(e.response!.statusCode.toString());
      print(
          'Failed Load Data with status code ${e.response!.statusCode}');
          return foundUser;
    }
  }
  
}