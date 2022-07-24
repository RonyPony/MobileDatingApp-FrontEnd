import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:inlove/providers/auth_provider.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';

class UserProfileScreen extends StatefulWidget {
  static String routeName = "/UserProfileScreen";

  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _StateUserProfile();
  
}

class _StateUserProfile extends State<UserProfileScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Future<User>_user;
  @override
  void initState() {
    final args = ModalRoute.of(context)!.settings.arguments as String;
    loadUser(args);
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _controller.repeat();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      useDefaultLoading: false,
      overlayWidget: Center(
          child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.black,
          boxShadow: const [
            BoxShadow(color: Colors.pink, spreadRadius: 3),
          ],
        ),

        height: MediaQuery.of(context).size.height * .25,
        // color: Colors.black,
        padding: const EdgeInsets.all(29),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _controller.view,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _controller.value * 2 * pi,
                  child: child,
                );
              },
              child: SvgPicture.asset(
                'assets/logo-no-name.svg',
                height: MediaQuery.of(context).size.height * .12,
              ),
            ),
            // CircularProgressIndicator(color:Colors.pink,),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Cargando...",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                  decoration: TextDecoration.none),
            )
          ],
        ),
      )),
      child:Scaffold()
    );
  }
  
  void loadUser(userId) {
    final authProvider = Provider.of<AuthProvider>(context,listen: false);
    Future<User>usr = authProvider.findUserById(userId);
    _user = usr;
  }

}
