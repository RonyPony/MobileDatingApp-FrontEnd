import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:inlove/providers/auth_provider.dart';
import 'package:inlove/providers/chat_provider.dart';
import 'package:inlove/providers/countries_provider.dart';
import 'package:inlove/providers/match_provider.dart';
import 'package:inlove/providers/photo_provider.dart';
import 'package:inlove/providers/settings_provider.dart';
import 'package:inlove/routes.dart';
import 'package:inlove/screens/landing.page.dart';
import 'package:inlove/services/auth_service.dart';
import 'package:inlove/services/countries_service.dart';
import 'package:inlove/services/match_service.dart';
import 'package:inlove/services/photo_service.dart';
import 'package:inlove/services/setting_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'providers/auth_provider.dart' as kk;
import 'firebase_options.dart';

void main() async {
  // ErrorWidget.builder = (FlutterErrorDetails details) {
  //   bool inDebug = false;
  //   assert(() {
  //     inDebug = true;
  //     return true;
  //   }());
  //   if (inDebug) {
  //     return ErrorWidget(details.exception);
  //   } else {
  //     return Container(
  //       alignment: Alignment.center,
  //       child: Text(
  //         'Hey, ha ocurrido un error ${details.exception}',
  //         style: TextStyle(color: Colors.yellow),
  //         textDirection: TextDirection.ltr,
  //       ),
  //     );
  //   }
  // };
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Activate app check after initialization, but before
  // usage of any Firebase services.
  // await FirebaseAppCheck.instance
  //     // Your personal reCaptcha public key goes here:
  //     .activate();
  final SharedPreferences shared = await SharedPreferences.getInstance();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
          create: (_) => kk.AuthProvider(
              authService: AuthService(
                  FirebaseAuth.instance, FirebaseFirestore.instance),
              firebaseAuth: FirebaseAuth.instance,
              firebaseFirestore: FirebaseFirestore.instance,
              googleSignIn: GoogleSignIn(),
              prefs: shared)),
      ChangeNotifierProvider(create: (_) => SettingsProvider(SettingService())),
      ChangeNotifierProvider(
          create: (_) => ChatProvider(
              FirebaseStorage.instance, FirebaseFirestore.instance)),
      ChangeNotifierProvider(create: (_) => MatchProvider(MatchService())),
      ChangeNotifierProvider(create: (_) => PhotoProvider(PhotoService())),
      ChangeNotifierProvider(
          create: (_) => CountriesProvider(CountriesService()))
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inlove App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LandingPage(),
      routes: routes,
    );
  }
}
