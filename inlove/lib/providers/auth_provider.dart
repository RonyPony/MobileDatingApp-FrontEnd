import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:inlove/models/sexual_orientations.dart';
import 'package:inlove/models/user_login.dart';
import 'package:inlove/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';
import '../models/user_register.dart';
import '../screens/chat_spike.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService authService;
  final GoogleSignIn googleSignIn;
  final fb_auth.FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;
  final SharedPreferences prefs;
   Status _status = Status.uninitialized;

  Status get status => _status;
  AuthProvider({
    required this.authService,
    required this.googleSignIn,
      required this.firebaseAuth,
      required this.firebaseFirestore,
      required this.prefs
  });

  Future<bool> userEmailExists(String userEmail) async {
    final bool response = await authService.userExists(userEmail);
    return response;
  }

  Future<bool> performLogin(Login userLogin) async {
    final bool response = await authService.performLogin(userLogin);
    return response;
  }

  Future<User>findUserByEmail(String userEmail) async {
    final user = await authService.findUserByEmail(userEmail);
    return user;
  }

  Future<User> readLocalUserInfo() async {
    final User response = await authService.readLocalUserInfo();
    return response;
  }

  Future<bool> updateUserInfo(User user) async {
    final bool response = await authService.updateUserInfo(user);
    return response;
  }

  Future<bool> registerUser(Register usuario) async {
    final bool response = await authService.registerUser(usuario);
    return response;
  }

  Future<bool> saveLocalUserInfoUser(User user) async {
    final bool response = await authService.saveLocalUserInfo(user);
    return response;
  }

  Future<List<SexualOrientation>> getAllSexualOrientations() async {
    final List<SexualOrientation> response = await authService.getAllSexes();
    return response;
  }

  Future<SexualOrientation> getSexualOrientationByName(String sexName) async {
    final SexualOrientation response =
        await authService.getSexualOrientationByName(sexName);
    return response;
  }

  Future<SexualOrientation> getSexualOrientationById(int id) async {
    final SexualOrientation response =
        await authService.getSexualOrientationById(id);
    return response;
  }

  Future<String?> getErrorMsg() async {
    final String? msg = await authService.getErrorMessage();
    return msg;
  }

  Future<User> findUserById(int userId) async {
    var response = await authService.findUserById(userId);
    return response;
  }

  Future<bool> logout() async {
    var response = await authService.performLogout();
    return response;
  }



  String? getFirebaseUserId() {
   return prefs.getString(FirestoreConstants.id);
 }

 Future<bool> isLoggedIn() async {
   bool isLoggedIn = await googleSignIn.isSignedIn();
   if (isLoggedIn &&
       prefs.getString(FirestoreConstants.id)?.isNotEmpty == true) {
     return true;
   } else {
     return false;
   }
 }

 Future<bool?> handleGoogleSignIn() async {
   try {
     _status = Status.authenticating;
      notifyListeners();

      GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      //  final GoogleSignIn _googleSignIn = GoogleSignIn(
      //     // scopes: [
      //     //   'https://www.googleapis.com/auth/drive',
      //     // ],
      //   );
// GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        GoogleSignInAuthentication? googleAuth =
            await googleUser.authentication;
        final fb_auth.AuthCredential credential =
            fb_auth.GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        fb_auth.User? firebaseUser =
            (await firebaseAuth.signInWithCredential(credential)).user;

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
              FirestoreConstants.id: firebaseUser.uid,
              "createdAt: ": DateTime.now().millisecondsSinceEpoch.toString(),
              FirestoreConstants.chattingWith: null
            });
          }
          User usua = await authService.findUserByEmail(firebaseUser.email!);
          if (usua != User()) {
            authService.saveLocalUserInfo(usua);
            return true;
          }
        }
      } else {
        return false;
      }
   } catch (e) {
     print("Error authenticating with google "+e.toString());
   }
 }

}

enum Status {
  uninitialized,
authenticating,
authenticateError,
authenticateCanceled,
authenticated
}