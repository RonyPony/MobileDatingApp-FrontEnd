// ignore_for_file: avoid_print, duplicate_ignore, unrelated_type_equality_checks

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:inlove/constant.dart';
import 'package:inlove/contracts/auth_contract.dart';
import 'package:inlove/models/sexual_orientations.dart';
import 'package:inlove/models/user.dart';
import 'package:inlove/models/user_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_register.dart';

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

      // ignore: unrelated_type_equality_checks
      if(resp.statusCode=="404"){
        if (kDebugMode) {
          print("User Not Found");
        }
      }
      return false;
    } 
    on DioError catch (e) {
      //http error(statusCode not 20x) will be catched here.
      if (kDebugMode) {
        print(e.response!.statusCode.toString());
      }
      if (kDebugMode) {
        print(
          'Failed Load Data with status code ${e.response!.statusCode}');
      }
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

      // ignore: unrelated_type_equality_checks, duplicate_ignore
      if(resp.statusCode=="404"){
        // ignore: avoid_print
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
      var res = prefs.getString(savedCurrentUserFlag);
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
    catch(e){
      print(e);
      return User();
    }
  }
  
  @override
  Future<bool> updateUserInfo(User user) async {
    try {
      var resp = await Dio().put(
          serverurl+'api/user/${user.id}',data: user);
      if(resp.statusCode == 200 || resp.statusCode==204){
        return true;
      }

      // ignore: unrelated_type_equality_checks
      if(resp.statusCode=="404" || resp.statusCode!.toInt()>400){
        if (kDebugMode) {
          print("User Not Modified");
        }
        return false;
      }
      return false;
    } 
    on DioError catch (e) {
      //http error(statusCode not 20x) will be catched here.
      if (kDebugMode) {
        print(e.response!.statusCode.toString());
      }
      if (kDebugMode) {
        print(
          'Failed Load Data with status code ${e.response!.statusCode}');
      }
          return false;
    }
  }

  @override
  Future<List<SexualOrientation>> getAllSexes() async {
    List<SexualOrientation> foundSexes = <SexualOrientation>[];
    try {
      var resp = await Dio().get(
          serverurl+'api/SexualOrientations');
      if(resp.statusCode == 200){
        
        var list  = resp.data;
        foundSexes = list.map<SexualOrientation>((sample) => SexualOrientation(
          id: sample["id"],
          enabled: sample["enabled"],
          name: sample["name"]
          )).toList();
        // foundCountry;
        return foundSexes;
      }

      if(resp.statusCode=="404"){
        print("Sex Not Found");
      }
      return foundSexes;
    } 
    on DioError catch (e) {
      //http error(statusCode not 20x) will be catched here.
      print(e.response!.statusCode.toString());
      print(
          'Failed Load Data with status code ${e.response!.statusCode}');
          return foundSexes;
    }
    catch(e){
      print(e);
      return foundSexes;
    } 
  }
  
  @override
  Future<SexualOrientation> getSexualOrientationByName(String sexName) async {
    SexualOrientation foundSex = SexualOrientation();
    try {
      var resp = await Dio().get(
          serverurl+'api/SexualOrientations/byName/$sexName');
      if(resp.statusCode == 200){
        
        var list  = resp.data;
         var jsoned = jsonEncode(resp.data);
        foundSex = SexualOrientation.fromJson(resp.data[0]);
        // foundCountry;
        return foundSex;
      }

      if(resp.statusCode=="404"){
        print("Sex Not Found");
      }
      return foundSex;
    } 
    on DioError catch (e) {
      //http error(statusCode not 20x) will be catched here.
      print(e.response!.statusCode.toString());
      print(
          'Failed Load Data with status code ${e.response!.statusCode}');
          return foundSex;
    }
    catch(e){
      print(e);
      return foundSex;
    } 
  }
  
  @override
  Future<bool> registerUser(Register user) {
    // TODO: implement registerUser
    throw UnimplementedError();
  }

  }
  

  