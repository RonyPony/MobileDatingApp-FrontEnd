import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inlove/models/user.dart';
import 'package:inlove/screens/profile.page.dart';
import 'package:loader_overlay/loader_overlay.dart';

class DeleteAccountScreen extends StatefulWidget {
  static String routeName = '/DeleteAcountScreen';
  const DeleteAccountScreen({Key? key}) : super(key: key);

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Future<User> localUserInfo;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeigth = MediaQuery.of(context).size.height;
    MaterialStateProperty<Color?> redColor =
        MaterialStateProperty.all<Color?>(Colors.red);
    MaterialStateProperty<Color?> whiteColor =
        MaterialStateProperty.all<Color?>(Colors.white);
    MaterialStateProperty<Color?> blackColor =
        MaterialStateProperty.all<Color?>(Colors.black);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          SizedBox(
            height: screenHeigth * .2,
          ),
          SvgPicture.asset('assets/logo-no-name.svg'),
          SizedBox(
            height: screenHeigth * .05,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Estas Seguro ?",
                style: TextStyle(color: Colors.white, fontSize: 28),
              ),
            ],
          ),
          SizedBox(
            height: screenHeigth * .02,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: screenWidth * .8,
                child: Text(
                  "Tu cuenta sera eliminada en un periodo de 24 horas, esta accion no se puede deshacer",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ],
          )
        ],
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
              style: ButtonStyle(
                backgroundColor: whiteColor,
                foregroundColor: blackColor,
              ),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, ProfileScreen.routeName, (route) => false);
              },
              child: Text("No, regresar")),
          SizedBox(
            width: screenWidth * .05,
          ),
          ElevatedButton(
              style: ButtonStyle(
                backgroundColor: redColor,
                foregroundColor: whiteColor,
              ),
              onPressed: () {},
              child: Text("Si, elimina mi informacion"))
        ],
      ),
    );
  }
}
