// ignore_for_file: avoid_print, duplicate_ignore, unrelated_type_equality_checks

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:inlove/constant.dart';
import 'package:inlove/contracts/auth_contract.dart';
import 'package:inlove/models/sexual_orientations.dart';
import 'package:inlove/models/user.dart';
import 'package:inlove/models/user_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_register.dart';
import '../screens/chat_spike.dart';

class AuthService implements AuthContract {
  String savedCurrentUserFlag = "la verdadera para tuya";
  final fbAuth.FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;

  AuthService(this.firebaseAuth, this.firebaseFirestore);
  @override
  Future<bool> performLogin(Login userLogin) async {
    try {
      var resp = await Dio().post(serverurl + 'api/user/login/', data: {
        "userEmail": "${userLogin.userEmail}",
        "password": "${userLogin.password}",
        "rememberMe": userLogin.rememberMe
      });
      if (resp.statusCode == 200) {
        fbAuth.User? firebaseUser =
            (await firebaseAuth.signInWithEmailAndPassword(
                    email: userLogin.userEmail!, password: userLogin.password!))
                .user;
        if (firebaseUser != null) {
          final QuerySnapshot result = await firebaseFirestore
              .collection(FirestoreConstants.pathUserCollection)
              .where(FirestoreConstants.id, isEqualTo: firebaseUser.uid)
              .get();
          final List<DocumentSnapshot> document = result.docs;
          if (document.isEmpty) {
            firebaseFirestore
                .collection(FirestoreConstants.pathUserCollection)
                .doc(firebaseUser.uid)
                .set({
              FirestoreConstants.displayName: firebaseUser.displayName,
              FirestoreConstants.photoUrl: firebaseUser.photoURL,
              FirestoreConstants.email: firebaseUser.email,
              FirestoreConstants.id: firebaseUser.uid,
              "createdAt: ": DateTime.now().millisecondsSinceEpoch.toString(),
              FirestoreConstants.chattingWith: null
            });
          }
          User usua = await findUserByEmail(firebaseUser.email!);
          if (usua != User()) {
            saveLocalUserInfo(usua);
            return true;
          }
        }
      }

      // ignore: unrelated_type_equality_checks
      if (resp.statusCode == "404") {
        if (kDebugMode) {
          print("User Not Found");
        }
      }
      return false;
    } on DioError catch (e) {
      //http error(statusCode not 20x) will be catched here.
      if (kDebugMode) {
        print(e.response!.statusCode.toString());
      }
      if (kDebugMode) {
        print('Failed Load Data with status code ${e.response!.statusCode}');
      }
      if (e.response!.statusCode == 423) {
        setErrorMessage(e.response!.data);
      }
      return false;
    } on fbAuth.FirebaseAuthException catch (fbE) {
      setErrorMessage(fbE.code);
      print(fbE.message);

      return false;
    } catch (e) {
      print("ERROR" + e.toString());
      return false;
    }
  }

  @override
  Future<bool> userExists(String userEmail) async {
    try {
      Dio client = Dio();
      var resp =
          await client.post(serverurl + 'api/user/findByEmail/' + userEmail);
      if (resp.statusCode == 200) {
        return true;
      }

      // ignore: unrelated_type_equality_checks, duplicate_ignore
      if (resp.statusCode == "404") {
        // ignore: avoid_print
        print("User Not Found");
      }
      return true;
    } on DioError catch (e) {
      //http error(statusCode not 20x) will be catched here.
      print(e.response!.statusCode.toString());
      print('Failed Load Data with status code ${e.response!.statusCode}');
      return false;
    }
  }

  @override
  Future<bool> saveLocalUserInfo(User usuario) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var res =
          await prefs.setString(savedCurrentUserFlag, jsonEncode(usuario));
      return res;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> setErrorMessage(String? error) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var res = await prefs.setString("ErrorMsg", error!);
      return res;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<String?> getErrorMessage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var res = await prefs.getString("ErrorMsg");
      setErrorMessage("");
      return res;
    } catch (e) {
      print(e);
      return "";
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
      var resp =
          await Dio().post(serverurl + 'api/user/findByEmail/' + userEmail);
      if (resp.statusCode == 200) {
        finalUser = User.fromJson(resp.data);
        return finalUser;
      }

      if (resp.statusCode == "404") {
        print("User Not Found");
      }
      return finalUser;
    } on DioError catch (e) {
      //http error(statusCode not 20x) will be catched here.
      print(e.response!.statusCode.toString());
      print('Failed Load Data with status code ${e.response!.statusCode}');
      return User();
    } catch (e) {
      print(e);
      return User();
    }
  }

  @override
  Future<bool> updateUserInfo(User user) async {
    try {
      var resp = await Dio().put(serverurl + 'api/user/${user.id}', data: user);
      if (resp.statusCode == 200 || resp.statusCode == 204) {
        return true;
      }

      // ignore: unrelated_type_equality_checks
      if (resp.statusCode == "404" || resp.statusCode!.toInt() > 400) {
        if (kDebugMode) {
          print("User Not Modified");
        }
        return false;
      }
      return false;
    } on DioError catch (e) {
      //http error(statusCode not 20x) will be catched here.
      if (kDebugMode) {
        print(e.response!.statusCode.toString());
      }
      if (kDebugMode) {
        print('Failed Load Data with status code ${e.response!.statusCode}');
      }
      return false;
    }
  }

  @override
  Future<List<SexualOrientation>> getAllSexes() async {
    List<SexualOrientation> foundSexes = <SexualOrientation>[];
    try {
      var resp = await Dio().get(serverurl + 'api/SexualOrientations');
      if (resp.statusCode == 200) {
        var list = resp.data;
        foundSexes = list
            .map<SexualOrientation>((sample) => SexualOrientation(
                id: sample["id"],
                enabled: sample["enabled"],
                name: sample["name"]))
            .toList();
        // foundCountry;
        return foundSexes;
      }

      if (resp.statusCode == "404") {
        print("Sex Not Found");
      }
      return foundSexes;
    } on DioError catch (e) {
      //http error(statusCode not 20x) will be catched here.
      print(e.response!.statusCode.toString());
      print('Failed Load Data with status code ${e.response!.statusCode}');
      return foundSexes;
    } catch (e) {
      print(e);
      return foundSexes;
    }
  }

  @override
  Future<SexualOrientation> getSexualOrientationByName(String sexName) async {
    SexualOrientation foundSex = SexualOrientation();
    try {
      var resp =
          await Dio().get(serverurl + 'api/SexualOrientations/byName/$sexName');
      if (resp.statusCode == 200) {
        var list = resp.data;
        var jsoned = jsonEncode(resp.data);
        foundSex = SexualOrientation.fromJson(resp.data[0]);
        // foundCountry;
        return foundSex;
      }

      if (resp.statusCode == "404") {
        print("Sex Not Found");
      }
      return foundSex;
    } on DioError catch (e) {
      //http error(statusCode not 20x) will be catched here.
      print(e.response!.statusCode.toString());
      print('Failed Load Data with status code ${e.response!.statusCode}');
      return foundSex;
    } catch (e) {
      print(e);
      return foundSex;
    }
  }

  @override
  Future<bool> registerUser(Register user) async {
    User finalUser = User();
    try {
      var resp = await Dio().post(serverurl + 'api/user', data: {
        "userName": "${user.userName}",
        "lastName": "${user.lastName}",
        "email": "${user.email}",
        "password": "${user.password}",
        "sex": "${user.sex}"
      });
      if (resp.statusCode == 200 || resp.statusCode == 201) {
        return true;
      }

      if (resp.statusCode == "404") {
        print("User Not Found");
      }
      return false;
    } on DioError catch (e) {
      //http error(statusCode not 20x) will be catched here.
      print(e.response!.statusCode.toString());
      print('Failed Load Data with status code ${e.response!.statusCode}');
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Future<SexualOrientation> getSexualOrientationById(int id) async {
    SexualOrientation foundSex = SexualOrientation();
    try {
      var resp = await Dio().get(serverurl + 'api/SexualOrientations/$id');
      if (resp.statusCode == 200) {
        var list = resp.data;
        var jsoned = jsonEncode(resp.data);
        foundSex = SexualOrientation.fromJson(list);
        // foundCountry;
        return foundSex;
      }

      if (resp.statusCode == "404") {
        print("Sex Not Found");
      }
      return foundSex;
    } on DioError catch (e) {
      //http error(statusCode not 20x) will be catched here.
      print(e.response!.statusCode.toString());
      print('Failed Load Data with status code ${e.response!.statusCode}');
      return foundSex;
    } catch (e) {
      print(e);
      return foundSex;
    }
  }

  @override
  Future<User> findUserById(int userId) async {
    User foundUser = User();
    try {
      var resp = await Dio().get(serverurl + 'api/user/$userId');
      if (resp.statusCode == 200) {
        User list = User.fromJson(resp.data);
        foundUser = list; //list.map<User>(User.fromJson(list)).toList();
      }

      if (resp.statusCode == "404") {
        print("User Not Found");
      }
      return foundUser;
    } on DioError catch (e) {
      //http error(statusCode not 20x) will be catched here.
      print(e.response!.statusCode.toString());
      print('Failed Load Data with status code ${e.response!.statusCode}');
      return foundUser;
    } catch (e) {
      print(e);
      return foundUser;
    }
  }

  @override
  Future<bool> performLogout() async {
    try {
      final fbAuth.FirebaseAuth _auth = fbAuth.FirebaseAuth.instance;
      GoogleSignIn ss = GoogleSignIn();
      ss.disconnect();
      await _auth.signOut();
      saveLocalUserInfo(User());
      return true;
    } catch (e) {
      return false;
    }
  }

  bool registerFirebaseUser(Login userLogin) {
    try {
      // if (fbE.code == "user-not-found" || fbE.code == "wrong-password") {
      //   print("Registering new firebase user");
      //   bool registered = registerFirebaseUser(userLogin);
      //   if (registered) {
      //     print("Registering new firebase user - Completed Successfully");
      //     fbAuth.User? firebaseUser =
      //         (await firebaseAuth.signInWithEmailAndPassword(
      //                 email: userLogin.userEmail!,
      //                 password: userLogin.password!))
      //             .user;
      //     if (firebaseUser != null) {
      //       final QuerySnapshot result = await firebaseFirestore
      //           .collection(FirestoreConstants.pathUserCollection)
      //           .where(FirestoreConstants.id, isEqualTo: firebaseUser.uid)
      //           .get();
      //       final List<DocumentSnapshot> document = result.docs;
      //       if (document.isEmpty) {
      //         firebaseFirestore
      //             .collection(FirestoreConstants.pathUserCollection)
      //             .doc(firebaseUser.uid)
      //             .set({
      //           FirestoreConstants.displayName: firebaseUser.displayName,
      //           FirestoreConstants.photoUrl: firebaseUser.photoURL,
      //           FirestoreConstants.email: firebaseUser.email,
      //           FirestoreConstants.id: firebaseUser.uid,
      //           "createdAt: ": DateTime.now().millisecondsSinceEpoch.toString(),
      //           FirestoreConstants.chattingWith: null
      //         });
      //       }
      //     }
      //     User usua = await findUserByEmail(userLogin.userEmail!);
      //     if (usua != User()) {
      //       saveLocalUserInfo(usua);
      //       return true;
      //     } else {
      //       return false;
      //     }
      //   }
      // }

      final fbAuth.FirebaseAuth _auth = fbAuth.FirebaseAuth.instance;
      _auth.createUserWithEmailAndPassword(
          email: userLogin.userEmail!, password: userLogin.password!);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<User> deleteAccount(int userId) async {
    User foundUser = User();
    try {
      var resp = await Dio().delete(serverurl + 'api/user/$userId');
      if (resp.statusCode == 200) {
        User list = User.fromJson(resp.data);
        foundUser = list; //list.map<User>(User.fromJson(list)).toList();
      }

      if (resp.statusCode == "404") {
        print("User Not Found");
      }
      return foundUser;
    } on DioError catch (e) {
      //http error(statusCode not 20x) will be catched here.
      print(e.response!.statusCode.toString());
      print('Failed Load Data with status code ${e.response!.statusCode}');
      return foundUser;
    } catch (e) {
      print(e);
      return foundUser;
    }
  }
}
