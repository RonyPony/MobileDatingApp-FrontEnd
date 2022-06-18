import 'package:flutter/cupertino.dart';
import 'package:inlove/screens/home.page.dart';
import 'package:inlove/screens/landing.page.dart';
import 'package:inlove/screens/login.page.dart';
import 'package:inlove/screens/profile.page.dart';
import 'package:inlove/screens/setting.page.dart';

final Map<String, WidgetBuilder> routes = {
  LandingPage.routeName: (context) => const LandingPage(),
  LoginPage.routeName: (context) => const LoginPage(),
  HomePage.routeName: (context) => const HomePage(),
  ProfileScreen.routeName: (context) => const ProfileScreen(),
  SettingScreen.routeName: (context) => const SettingScreen(),
};
