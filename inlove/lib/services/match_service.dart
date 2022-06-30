import 'package:cool_alert/cool_alert.dart';
import 'package:dio/dio.dart';
import 'package:inlove/contracts/match_contract.dart';
import 'package:inlove/models/user.dart';
import 'package:inlove/models/userMatch.dart';

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
      foundUser.hasError = true;
      foundUser.error="unknown";
      return foundUser;
    } 
    on DioError catch (e) {
      //http error(statusCode not 20x) will be catched here.
      var responseInfo=e.response!.data;
      // if (responseInfo.contains("R386")) {

      // }
      print(e.response!.statusCode.toString());
      print('Failed Load Data with status code ${e.response!.statusCode}');
      foundUser.hasError = true;
      
      foundUser.error = responseInfo;
      return foundUser;
    }catch(e){
      print(e);
      foundUser.hasError = true;
      foundUser.error = e.toString();
      return foundUser;
    }
  }
  
  @override
  Future<bool> createMatch(int originUserId, int destinUserId) async {
    try {
      UserMatch match = UserMatch(originUserId: originUserId,finalUserId: destinUserId,isAcepted: false);
      var resp = await Dio().post(
          serverurl+'api/matches',data: match);
      if(resp.statusCode == 200 || resp.statusCode == 201){
        print(resp.statusMessage);
        return true;
      }

      if(resp.statusCode=="404"){
        print("User Not Found");
        return false;
      }
      return false;
    } 
    on DioError catch (e) {
      //http error(statusCode not 20x) will be catched here.
      print(e.response!.statusCode.toString());
      print(
          'Failed Load Data with status code ${e.response!.statusCode}');
          return false;
    }
  }
  
}
