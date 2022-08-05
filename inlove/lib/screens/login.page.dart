import 'dart:math';

import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:inlove/controls/link_buttom.dart';
import 'package:inlove/helpers/emojies.dart';
import 'package:inlove/models/user_login.dart';
import 'package:inlove/screens/home.page.dart';
import 'package:inlove/screens/register.page.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

import '../controls/text_box.dart';
import '../providers/auth_provider.dart';

class LoginPage extends StatefulWidget {
  static String routeName = "/LoginPage";

  const LoginPage({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final emailController = TextEditingController(text: "");
  final passController = TextEditingController(text: "");

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _controller.repeat();
    if (kDebugMode) {
      emailController.text = "ronel.cruz.a8@gmail.com";
      passController.text = "ronel0808";
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const String usersAsset = 'assets/users.svg';
    final Widget user = SvgPicture.asset(
      usersAsset,
      // color: Colors.blue,
    );

    final authProvider = Provider.of<AuthProvider>(context);

    switch (authProvider.status) {
      case Status.authenticateError:
        Fluttertoast.showToast(msg: 'Sign in failed');
        break;
      case Status.authenticateCanceled:
        Fluttertoast.showToast(msg: 'Sign in cancelled');
        break;
      case Status.authenticated:
        Fluttertoast.showToast(msg: 'Sign in successful');
        break;
      default:
        break;
    }

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
              "Iniciando Sesion...",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                  decoration: TextDecoration.none),
            )
          ],
        ),
      )),
      child: Scaffold(
        backgroundColor: const Color(0xff020202),
        body: SingleChildScrollView(
            // controller: controller,
            child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Padding(
                  padding: EdgeInsets.only(top: 70, bottom: 20),
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
                color: const Color(0xff1b1b1b),
              ),
              child: Column(
                children: [
                  user,
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: CustomTextBox(
                      text: "Correo Electronico",
                      onChange: () {},
                      controller: emailController,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: CustomTextBox(
                      isPassword: true,
                      onChange: () {},
                      text: "Clave",
                      controller: passController,
                    ),
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
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, RegisterPage.routeName);
              },
              child: const CustomLinkButton(
                tittle: "O Registrate",
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: _buildGoogleLoginButton(),
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
                    child: const Text(
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
        )),
      ),
    );
  }

  Widget buildEnterButton() {
    return SizedBox(
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
                  color: const Color(0xff1db9fc),
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
                        try {
                          context.loaderOverlay.show();
                          final authProvider =
                              Provider.of<AuthProvider>(context, listen: false);
                          final userExists = await authProvider
                              .userEmailExists(emailController.text);
                          if (userExists) {
                            if (kDebugMode) {
                              print("User Exists");
                            }
                            Login info = Login(
                                userEmail: emailController.text,
                                password: passController.text,
                                rememberMe: false);
                            final bool logged =
                                await authProvider.performLogin(info);
                            if (logged) {
                              Navigator.pushNamedAndRemoveUntil(context,
                                  HomePage.routeName, (route) => false);
                            } else {
                              String? errMsg = await authProvider.getErrorMsg();
                              Emojies emo = Emojies();
                              if (errMsg == "user-not-found") {
                                await authProvider.registerFirebaseUser(info);
                                final bool logged =
                                    await authProvider.performLogin(info);
                                if (logged) {
                                  Navigator.pushNamedAndRemoveUntil(context,
                                      HomePage.routeName, (route) => false);
                                  CoolAlert.show(
                                    context: context,
                                    animType: CoolAlertAnimType.slideInDown,
                                    backgroundColor: Colors.white,
                                    loopAnimation: false,
                                    type: CoolAlertType.loading,
                                    title: "😍😍",
                                    text:
                                        "Hey, es grandioso que formes parte del grupo ❤️",
                                  );
                                }
                              } else {
                                if (errMsg == "") {
                                  CoolAlert.show(
                                    context: context,
                                    animType: CoolAlertAnimType.slideInDown,
                                    backgroundColor: Colors.white,
                                    loopAnimation: false,
                                    type: CoolAlertType.error,
                                    text:
                                        "Credenciales incorrectas, por favor intentalo de nuevo ${emo.getAnEmmoji(false)}",
                                  );
                                } else {
                                  CoolAlert.show(
                                    context: context,
                                    animType: CoolAlertAnimType.slideInDown,
                                    backgroundColor: Colors.white,
                                    loopAnimation: false,
                                    type: CoolAlertType.info,
                                    title: "Informacion",
                                    text: errMsg,
                                  );
                                }
                              }
                            }
                          } else {
                            Emojies emo = Emojies();
                            CoolAlert.show(
                              context: context,
                              animType: CoolAlertAnimType.slideInDown,
                              backgroundColor: Colors.white,
                              loopAnimation: false,
                              type: CoolAlertType.error,
                              text:
                                  "Este correo electronico no esta registrado, favor verificalo ${emo.getAnEmmoji(false)}",
                            );
                          }
                          context.loaderOverlay.hide();
                        } catch (e) {
                          Emojies emo = Emojies();
                          context.loaderOverlay.hide();
                          if (e is FirebaseAuthException) {
                            CoolAlert.show(
                                context: context,
                                animType: CoolAlertAnimType.slideInDown,
                                backgroundColor: Colors.white,
                                loopAnimation: false,
                                type: CoolAlertType.error,
                                title: "ERROR de autenticacion",
                                text: e.message.toString() +
                                    emo.getAnEmmoji(false));
                          } else {
                            CoolAlert.show(
                                context: context,
                                animType: CoolAlertAnimType.slideInDown,
                                backgroundColor: Colors.white,
                                loopAnimation: false,
                                type: CoolAlertType.error,
                                title: "ERROR",
                                text: e.toString() + emo.getAnEmmoji(false));
                          }
                        } finally {
                          context.loaderOverlay.hide();
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
    const String usersAsset = 'assets/users.svg';
    final Widget user = SvgPicture.asset(
      usersAsset,
      // color: Colors.blue,
    );
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
              color: const Color(0xff1b1b1b),
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
                      color: const Color(0xfc616161),
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
                      color: const Color(0xfc616161),
                    ),
                  ),
                ),
                const Positioned(
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
                const Positioned(
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

  _buildGoogleLoginButton() {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return GestureDetector(
          onTap: () async {
            final authProvider =
                Provider.of<AuthProvider>(context, listen: false);
            bool? isSuccess = await authProvider.handleGoogleSignIn();
            if (isSuccess == null) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const HomePage()));
            } else {
              Fluttertoast.showToast(
                  msg: 'Ups, algo paso con Google confirmando tu identidad',
                  backgroundColor: Colors.red);
            }
          },
          child: Container(
            width: 280,
            decoration: BoxDecoration(
                color: Color(0xff1db9fc), borderRadius: BorderRadius.circular(30)),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                         borderRadius: BorderRadius.circular(50)),
                    child: SvgPicture.asset(
                      "assets/google.svg",
                      width: 30,
                    )),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Inicia sesion con Google",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                )
              ],
            ),
          ));
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
//iOS specific code
    } else {
//web or desktop specific code
    }
  }
}
