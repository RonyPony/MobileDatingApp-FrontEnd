import 'package:flutter/cupertino.dart';
import 'package:inlove/screens/home.page.dart';
import 'package:inlove/screens/landing.page.dart';
import 'package:inlove/screens/login.page.dart';
import 'package:inlove/screens/profile.page.dart';
import 'package:inlove/screens/setting.page.dart';

final Map<String, WidgetBuilder> routes = {
  LandingPage.routeName: (context) => LandingPage(),
  LoginPage.routeName: (context) => LoginPage(),
  HomePage.routeName: (context) => HomePage(),
  ProfileScreen.routeName: (context) => ProfileScreen(),
  SettingScreen.routeName: (context) => SettingScreen(),
};
