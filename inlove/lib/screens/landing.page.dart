import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inlove/screens/login.page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);
  static String routeName = "/landingPage";
  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    const String assetName = 'assets/landing.svg';
    const String assetNameLanding = 'assets/mainLanding.svg';
    final Widget next = SvgPicture.asset(
      assetName,
      // color: Colors.blue,
    );
    final Widget landingPic = SvgPicture.asset(
      assetNameLanding,
      height: MediaQuery.of(context).size.height * .46,
      // color: Colors.blue,
    );
    return Scaffold(
      backgroundColor: const Color(0xff020202),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [landingPic],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Padding(
            padding: EdgeInsets.only(bottom: 50),
            child: Text(
              "It’s time to find Love",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
              ),
            ),
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              // print('next');
              Navigator.pushNamedAndRemoveUntil(
                  context, LoginPage.routeName, (route) => false);
            },
            child: Container(
              child: next,
              // color: Colors.red,
            ),
          )
        ],
      )
        ],
      ),
    );
  }

}
