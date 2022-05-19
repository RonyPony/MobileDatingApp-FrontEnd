import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginPage extends StatefulWidget {
  static String routeName = "/LoginPage";
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final String usersAsset = 'assets/Users.svg';
    final Widget user = SvgPicture.asset(
      usersAsset,
      // color: Colors.blue,
    );
    return Scaffold(
        backgroundColor: Color(0xff020202),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Iniciar Sesion",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                  ),
                ),
              ],
            ),
            Container(
              color: Colors.red,
              child: user,
            )
          ],
        ));
  }
}
