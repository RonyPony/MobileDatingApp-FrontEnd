import 'package:flutter/material.dart';
import 'package:inlove/routes/export.dart';

class LoginPage extends StatefulWidget {
  static String routeName = "/LoginPage";
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: color020202,
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Iniciar Sesion",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28.fS,
                  ),
                ),
              ],
            ),
            prebuiltPanel(),
            CustomButton()
          ],
        ));
  }

  Widget prebuiltPanel() {
    return SizedBox(
      width: 348,
      height: 303,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * .8,
            height: MediaQuery.of(context).size.height * .7,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(26),
              color: color1b1b1b,
            ),
            child: Stack(
              children: [
                Positioned(
                  left: 36,
                  top: 151,
                  child: Container(
                    width: 282,
                    height: 47,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(13),
                      color: color616161,
                    ),
                  ),
                ),
                Positioned(
                  left: 36,
                  top: 221,
                  child: Container(
                    width: 282,
                    height: 47,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(13),
                      color: color616161,
                    ),
                  ),
                ),
                Positioned(
                  left: 87,
                  top: 162,
                  child: SizedBox(
                    width: 231.dW,
                    child: Text(
                      "Correo Electronico",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21.fS,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 139.99,
                  top: 232,
                  child: Text(
                    "Clave",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21.fS,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      AppImages.usersAsset,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
