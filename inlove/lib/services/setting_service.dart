// ignore_for_file: unrelated_type_equality_checks, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:inlove/contracts/settings_contract.dart';
import 'package:inlove/models/user.dart';
import 'package:inlove/services/auth_service.dart';

import '../constant.dart';

class SettingService implements SettingsContract{
  final AuthService _authService = AuthService(fb_auth.FirebaseAuth.instance,FirebaseFirestore.instance);
  @override
  Future<bool> activateGhostMode(int userId) async {
    User currentUser = await _authService.readLocalUserInfo();
    currentUser.modoFantasma=true;
    try {
      
      var resp = await Dio().put(serverurl + 'api/user/$userId', data: currentUser.toJson());
      
      if (resp.statusCode == 200 || resp.statusCode == 204) {
        _authService.saveLocalUserInfo(currentUser);
        return true;
      }

      if (resp.statusCode == "404") {
        print("User Not modified");
        return false;
      }
      return false;
    } on DioError catch (e) {
      //http error(statusCode not 20x) will be catched here.
      print(e.response!.statusCode.toString());
      print('Failed Load Data with status code ${e.response!.statusCode}');
      return false;
    }
  }

  @override
  Future<bool> activateInstagram(int userId) async {
    
    User currentUser = await _authService.readLocalUserInfo();
    currentUser.instagramUserEnabled=true;
    try {
      var resp = await Dio().put(serverurl + 'api/user/$userId', data: currentUser.toJson());
      
      if (resp.statusCode == 200 || resp.statusCode == 204) {
        _authService.saveLocalUserInfo(currentUser);
        return true;
      }

      if (resp.statusCode == "404") {
        print("User Not modified");
        return false;
      }
      return false;
    } on DioError catch (e) {
      //http error(statusCode not 20x) will be catched here.
      print(e.response!.statusCode.toString());
      print('Failed Load Data with status code ${e.response!.statusCode}');
      return false;
    }
  }

  @override
  Future<bool> activateWhatsapp(int userId) async {
    User currentUser = await _authService.readLocalUserInfo();
    currentUser.whatsappNumberEnabled=true;
    try {
      var resp = await Dio().put(serverurl + 'api/user/$userId', data: currentUser.toJson());
      
      if (resp.statusCode == 200 || resp.statusCode == 204) {
        _authService.saveLocalUserInfo(currentUser);
        return true;
      }

      if (resp.statusCode == "404") {
        print("User Not modified");
        return false;
      }
      return false;
    } on DioError catch (e) {
      //http error(statusCode not 20x) will be catched here.
      print(e.response!.statusCode.toString());
      print('Failed Load Data with status code ${e.response!.statusCode}');
      return false;
    }
  }

  @override
  Future<bool> deactivateGhostMode(int userId) async {
    User currentUser = await _authService.readLocalUserInfo();
    currentUser.modoFantasma=false;
    try {
      var resp = await Dio().put(serverurl + 'api/user/$userId', data: currentUser.toJson());
      
      if (resp.statusCode == 200 || resp.statusCode == 204) {
        _authService.saveLocalUserInfo(currentUser);
        return true;
      }

      if (resp.statusCode == "404") {
        print("User Not modified");
        return false;
      }
      return false;
    } on DioError catch (e) {
      //http error(statusCode not 20x) will be catched here.
      print(e.response!.statusCode.toString());
      print('Failed Load Data with status code ${e.response!.statusCode}');
      return false;
    }
  }

  @override
  Future<bool> deactivateInstagram(int userId) async {
    User currentUser = await _authService.readLocalUserInfo();
    currentUser.instagramUserEnabled=false;
    try {
      var resp = await Dio().put(serverurl + 'api/user/$userId', data: currentUser.toJson());
      
      if (resp.statusCode == 200 || resp.statusCode == 204) {
        _authService.saveLocalUserInfo(currentUser);
        return true;
      }

      if (resp.statusCode == "404") {
        print("User Not modified");
        return false;
      }
      return false;
    } on DioError catch (e) {
      //http error(statusCode not 20x) will be catched here.
      print(e.response!.statusCode.toString());
      print('Failed Load Data with status code ${e.response!.statusCode}');
      return false;
    }
  }

  @override
  Future<bool> deactivateWhatsapp(int userId) async {
    User currentUser = await _authService.readLocalUserInfo();
    currentUser.whatsappNumberEnabled=false;
    try {
      var resp = await Dio().put(serverurl + 'api/user/$userId', data: currentUser.toJson());
      
      if (resp.statusCode == 200 || resp.statusCode == 204) {
        _authService.saveLocalUserInfo(currentUser);
        return true;
      }

      if (resp.statusCode == "404") {
        print("User Not modified");
        return false;
      }
      return false;
    } on DioError catch (e) {
      //http error(statusCode not 20x) will be catched here.
      print(e.response!.statusCode.toString());
      print('Failed Load Data with status code ${e.response!.statusCode}');
      return false;
    }
  }

  @override
  Future<bool> setInstagram(int userId, String instagramUser) async {
    User currentUser = await _authService.readLocalUserInfo();
    currentUser.instagramUser=instagramUser;
    try {
      var resp = await Dio().put(serverurl + 'api/user/$userId', data: currentUser.toJson());
      
      if (resp.statusCode == 200 || resp.statusCode == 204) {
        _authService.saveLocalUserInfo(currentUser);
        return true;
      }

      if (resp.statusCode == "404") {
        print("User Not modified");
        return false;
      }
      return false;
    } on DioError catch (e) {
      //http error(statusCode not 20x) will be catched here.
      print(e.response!.statusCode.toString());
      print('Failed Load Data with status code ${e.response!.statusCode}');
      return false;
    }
  }

  @override
  Future<bool> setWhatsapp(int userId, String whatsappNumber) async {
    User currentUser = await _authService.readLocalUserInfo();
    currentUser.whatsappNumber=whatsappNumber;
    try {
      var resp = await Dio().put(serverurl + 'api/user/$userId', data: currentUser.toJson());
      
      if (resp.statusCode == 200 || resp.statusCode == 204) {
        _authService.saveLocalUserInfo(currentUser);
        return true;
      }

      if (resp.statusCode == "404") {
        print("User Not modified");
        return false;
      }
      return false;
    } on DioError catch (e) {
      //http error(statusCode not 20x) will be catched here.
      print(e.response!.statusCode.toString());
      print('Failed Load Data with status code ${e.response!.statusCode}');
      return false;
    }
  }
  
  @override
  Future<bool> setFiltersPreferences(int userId, User userWithChanges) async {
    try {
      var resp = await Dio().put(serverurl + 'api/user/$userId', data: userWithChanges.toJson());
      
      if (resp.statusCode == 200 || resp.statusCode == 204) {
        _authService.saveLocalUserInfo(userWithChanges);
        return true;
      }

      if (resp.statusCode == "404") {
        print("User Not modified");
        return false;
      }
      return false;
    } on DioError catch (e) {
      //http error(statusCode not 20x) will be catched here.
      print(e.response!.statusCode.toString());
      print('Failed Load Data with status code ${e.response!.statusCode}');
      return false;
    }
  }
  
  @override
  Future<bool> updateSexuality( bool showSexuality) async {
    User currentUser = await _authService.readLocalUserInfo();
    currentUser.showMySexuality=showSexuality;
    try {
      var resp = await Dio().put(serverurl + 'api/user/${currentUser.id}', data: currentUser.toJson());
      
      if (resp.statusCode == 200 || resp.statusCode == 204) {
        _authService.saveLocalUserInfo(currentUser);
        return true;
      }

      if (resp.statusCode == "404") {
        print("User Not modified");
        return false;
      }
      return false;
    } on DioError catch (e) {
      //http error(statusCode not 20x) will be catched here.
      print(e.response!.statusCode.toString());
      print('Failed Load Data with status code ${e.response!.statusCode}');
      return false;
    }
  }
  
}