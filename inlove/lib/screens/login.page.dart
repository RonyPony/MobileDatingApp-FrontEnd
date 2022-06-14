import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inlove/controls/linkButtom.dart';
import 'package:inlove/controls/mainbtn.dart';
import 'package:inlove/models/userLogin.dart';
import 'package:inlove/screens/home.page.dart';
import 'package:provider/provider.dart';

import '../controls/textBox.dart';
import '../models/user.dart';
import '../providers/authProvider.dart';

class LoginPage extends StatefulWidget {
  static String routeName = "/LoginPage";
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {


    final emailController = TextEditingController();
  final passController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    final String usersAsset = 'assets/users.svg';
    final Widget user = SvgPicture.asset(
      usersAsset,
      // color: Colors.blue,
    );

    return Scaffold(
        backgroundColor: Color(0xff020202),
        body: SingleChildScrollView(
          // controller: controller,
          child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 70, bottom: 20),
                child: Text(
                  "Iniciar Sesion",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                  ),
                ),
              ),
            ],
          ),
          Container(
            width: MediaQuery.of(context).size.width * .9,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(26),
              color: Color(0xff1b1b1b),
            ),
            child: Column(
              children: [
                user,
                CustomTextBox(
                  text: "Correo Electronico",
                  controller: emailController,
                ),
                CustomTextBox(
                  text: "Clave",
                  controller: passController,
                ),
              ],
            ),
          ),
          // prebuiltPanel(),
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: buildEnterButton(),
          ),
          const SizedBox(
            height: 10,
          ),
          const CustomLinkButton(
            tittle: "O Registrate",
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 60, right: 30),
                child: GestureDetector(
                  onTap: (() {
                    Navigator.pushNamedAndRemoveUntil(
                        context, HomePage.routeName, (route) => false);
                  }),
                  child: Text(
                    "Saltar",
                    style: TextStyle(
                      color: Color(0x9effffff),
                      fontSize: 20,
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      )
        ),);
  }

  Widget buildEnterButton(){
    return Container(
      width: 181,
      height: 65,
      child: Stack(
        children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.topLeft,
              child: Container(
                width: 181,
                height: 53,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  color: Color(0xff1db9fc),
                ),
                padding: const EdgeInsets.only(
                  left: 37,
                  right: 69,
                  top: 11,
                  bottom: 9,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                          final authProvider =
                              Provider.of<AuthProvider>(context, listen: false);
                          final userExists =
                              await authProvider.userEmailExists(emailController.text);
                          if (userExists) {
                            print("User Exists");
                            Login info = Login(userEmail: emailController.text,password: passController.text,rememberMe: false);
                            final bool logged = await authProvider.performLogin(info);
                            if (logged) {
                              Navigator.pushNamedAndRemoveUntil(context, HomePage.routeName, (route) => false);
                            }
                          }else{
                            print("nothing");
                          }
                      },
                      child: const Text(
                        "Entrar",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 110,
            top: 0,
            child: Container(
                width: 70,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SvgPicture.asset('assets/flecha.svg')),
          ),
        ],
      ),
    );
  }

  Widget prebuiltPanel() {
    final String usersAsset = 'assets/users.svg';
    final Widget user = SvgPicture.asset(
      usersAsset,
      // color: Colors.blue,
    );
    return Container(
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
              color: Color(0xff1b1b1b),
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
                      color: Color(0xfc616161),
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
                      color: Color(0xfc616161),
                    ),
                  ),
                ),
                Positioned(
                  left: 87,
                  top: 162,
                  child: SizedBox(
                    width: 231,
                    child: Text(
                      "Correo Electronico",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 139.99,
                  top: 232,
                  child: SizedBox(
                    width: 51.26,
                    child: Text(
                      "Clave",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    user,
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
