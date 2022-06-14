import 'dart:convert';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:inlove/constant.dart';
import 'package:inlove/contracts/authContract.dart';
import 'package:inlove/models/userLogin.dart';
import 'package:inlove/providers/authProvider.dart';

class AuthService implements AuthContract{
  @override
  Future<bool> performLogin(Login userLogin) async {
    try {
      var resp = await Dio().post(
          serverurl+'api/user/login/',data: {
        "userEmail": "${userLogin.userEmail}",
        "password": "${userLogin.password}",
        "rememberMe": userLogin.rememberMe
      });
      if(resp.statusCode == 200){
        return true;
      }

      if(resp.statusCode=="404"){
        print("User Not Found");
      }
      return true;
    } 
    on DioError catch (e) {
      //http error(statusCode not 20x) will be catched here.
      print(e.response!.statusCode.toString());
      print(
          'Failed Load Data with status code ${e.response!.statusCode}');
          return false;
    }
    
  }
  
  @override
  Future<bool> userExists(String userEmail) async {
    try {
      var resp = await Dio().post(
          serverurl+'api/user/findByEmail/'+userEmail);
      if(resp.statusCode == 200){
        return true;
      }

      if(resp.statusCode=="404"){
        print("User Not Found");
      }
      return true;
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
  

  