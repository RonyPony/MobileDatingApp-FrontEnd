import 'dart:math';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:inlove/screens/login.page.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

import '../controls/text_box.dart';
import '../models/user_register.dart';
import '../providers/auth_provider.dart';

class RegisterPage extends StatefulWidget {
  static String routeName = '/registerForm';
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  TextEditingController nameController = TextEditingController();

  TextEditingController lastNameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController passController = TextEditingController();

  TextEditingController passValidationController = TextEditingController();

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _controller.repeat();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Widget user = Icon(
      Icons.person_add_rounded,
      color: Colors.grey,
      size: 90,
    );
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
                "Validando informacion...",
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
            appBar: AppBar(
              title: Text("Registrate"),
              backgroundColor: Colors.black,
              elevation: 0,
            ),
            backgroundColor: const Color(0xff020202),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * .9,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(26),
                          color: const Color(0xff1b1b1b),
                        ),
                        child: Column(
                          children: [
                            user,
                            CustomTextBox(
                              text: "Nombre",
                              onChange: () {},
                              controller: nameController,
                            ),
                            CustomTextBox(
                              onChange: () {},
                              text: "Apellidos",
                              controller: lastNameController,
                            ),
                            CustomTextBox(
                              onChange: () {},
                              text: "Correo Electronico",
                              controller: emailController,
                            ),
                            CustomTextBox(
                              onChange: () {},
                              isPassword: true,
                              text: "Clave",
                              controller: passController,
                            ),
                            CustomTextBox(
                              onChange: () {},
                              isPassword: true,
                              text: "Repetir Clave",
                              controller: passValidationController,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            buildRegisterButton()
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )));
  }

  Widget buildRegisterButton() {
    return GestureDetector(
      onTap: () async {
        try {
          context.loaderOverlay.show();
          final authProvider =
              Provider.of<AuthProvider>(context, listen: false);
          final userExists =
              await authProvider.userEmailExists(emailController.text);
          if (userExists) {
            CoolAlert.show(
              context: context,
              animType: CoolAlertAnimType.slideInDown,
              backgroundColor: Colors.white,
              loopAnimation: false,
              type: CoolAlertType.confirm,
              showCancelBtn: true,
              title: "Correo ya existe",
              cancelBtnText: "Uso otro correo",
              confirmBtnText: "Inicia sesion",
              onConfirmBtnTap: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, LoginPage.routeName, (route) => false);
              },
              text:
                  "Este correo electronico ya esta registrado, quieres iniciar sesion o usar otro correo 😅?",
            );
          } else {
            if (passController.text != passValidationController.text) {
              CoolAlert.show(
                  context: context,
                  animType: CoolAlertAnimType.slideInDown,
                  backgroundColor: Colors.white,
                  loopAnimation: false,
                  type: CoolAlertType.warning,
                  title: "Claves no coinciden",
                  text:
                      "Las claves ingresadas no coinciden, favor reingresar las claves 🥲");
              setState(() {
                passController.text = "";
                passValidationController.text = "";
              });
            } else {
              bool canRegister = false;
              String? err = "";
              if (nameController.text == "" ||
                  nameController.text.length <= 3) {
                err = err + "\nEl nombre debe tener mas de 3 caracteres";
              }
              if (lastNameController.text == "" ||
                  lastNameController.text.length <= 3) {
                err = err + "\nEl apellido debe ser mayor a 3 caracteres";
              }
              if (emailController.text == "" ||
                  emailController.text.length <= 3) {
                err = err + "\nEmail incorrecto";
              }
              if (passController.text == "" ||
                  passController.text.length <= 3) {
                err = err+ "\nClave incorrecta";
              }
              if (err == "") {
                canRegister = true;
              }
              if (canRegister) {
                Register info = Register(
                  email: emailController.text,
                  userName: nameController.text,
                  lastName: lastNameController.text,
                  password: passController.text,
                );
                final bool registered = await authProvider.registerUser(info);
                if (registered) {
                  CoolAlert.show(
                    context: context,
                    animType: CoolAlertAnimType.slideInDown,
                    backgroundColor: Colors.white,
                    loopAnimation: false,
                    onConfirmBtnTap: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, LoginPage.routeName, (route) => false);
                    },
                    confirmBtnText: "Iniciar Sesion",
                    title: "Registrado",
                    type: CoolAlertType.success,
                    text: "Cool, bienvenido a la familia 🥰",
                  );
                } else {
                  CoolAlert.show(
                    context: context,
                    animType: CoolAlertAnimType.slideInDown,
                    backgroundColor: Colors.white,
                    loopAnimation: false,
                    type: CoolAlertType.error,
                    text:
                        "Ha ocurrido un error al registrarte, por favor intentalo de nuevo.",
                  );
                }
              } else {
                CoolAlert.show(
                    context: context,
                    animType: CoolAlertAnimType.slideInDown,
                    backgroundColor: Colors.white,
                    loopAnimation: false,
                    type: CoolAlertType.error,
                    text: err);
              }
            }
          }
          context.loaderOverlay.hide();
        } catch (e) {
          context.loaderOverlay.hide();
          CoolAlert.show(
              context: context,
              animType: CoolAlertAnimType.slideInDown,
              backgroundColor: Colors.white,
              loopAnimation: false,
              type: CoolAlertType.error,
              title: "ERROR",
              text: e.toString());
        } finally {
          context.loaderOverlay.hide();
        }
      },
      child: SizedBox(
        width: 200,
        height: 65,
        child: Stack(
          children: [
            Positioned.fill(
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: 200,
                  height: 53,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    color: const Color(0xff1db9fc),
                  ),
                  padding: const EdgeInsets.only(
                    left: 17,
                    right: 69,
                    top: 10,
                    bottom: 10,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Registrate",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 23,
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
              bottom: 10,
              child: Container(
                  width: 100,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SvgPicture.asset('assets/flecha.svg')),
            ),
          ],
        ),
      ),
    );
  }
}
