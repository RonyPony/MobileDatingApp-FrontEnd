import 'dart:convert';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:inlove/constant.dart';
import 'package:inlove/contracts/authContract.dart';
import 'package:inlove/models/user.dart';
import 'package:inlove/models/userLogin.dart';
import 'package:inlove/providers/authProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService implements AuthContract{
  String savedCurrentUserFlag = "la verdadera para tuya";

  
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
        Future<User> usua = findUserByEmail(userLogin.userEmail!);
        saveLocalUserInfo(await usua);
        return true;
      }

      if(resp.statusCode=="404"){
        print("User Not Found");
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

  @override
  Future<bool> saveLocalUserInfo(User usuario) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var res = await prefs.setString(savedCurrentUserFlag,jsonEncode(usuario));
      return res;
    } catch (e) {
      print(e);
      return false;
    }

  }
  
  @override
  Future<User> readLocalUserInfo() async {
    
      final prefs = await SharedPreferences.getInstance();
      var res = await prefs.getString(savedCurrentUserFlag);
      User finalUser = User.fromJson(jsonDecode(res!));
      return finalUser;
    
  }
  
  @override
  Future<User> findUserByEmail(String userEmail) async {
    User finalUser = User();
    try {
      var resp = await Dio().post(
          serverurl+'api/user/findByEmail/'+userEmail);
      if(resp.statusCode == 200){
        finalUser = User.fromJson(resp.data);
        return finalUser;
      }

      if(resp.statusCode=="404"){
        print("User Not Found");
      }
      return finalUser;
    } 
    on DioError catch (e) {
      //http error(statusCode not 20x) will be catched here.
      print(e.response!.statusCode.toString());
      print(
          'Failed Load Data with status code ${e.response!.statusCode}');
          return User();
    }
  }
  }
  

  