import 'package:flutter/cupertino.dart';
import 'package:inlove/screens/landing.page.dart';
import 'package:inlove/screens/login.page.dart';

final Map<String, WidgetBuilder> routes = {
  LandingPage.routeName: (context) => LandingPage(),
  LoginPage.routeName: (context) => LoginPage(),
};
