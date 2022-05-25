import 'package:flag/flag_enum.dart';
import 'package:flag/flag_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../controls/menu.dart';

class ProfileScreen extends StatefulWidget {
  static String routeName = '/ProfileScreen';
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width * 1;

    double screenHeight = MediaQuery.of(context).size.height * 1;
    return Scaffold(
      bottomNavigationBar: MainMenu(),
      backgroundColor: Color(0xff020202),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xff020202),
        title: Text('LoVers - Perfil'),
      ),
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
                    color: Color(0xff1b1b1b),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 010, left: 10, right: 10, bottom: 10),
                        child: Image.asset(
                          "assets/man.png",
                          height: 300,
                        ),
                      ),
                      Container(
                        // color: Colors.red,
                        height: 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: screenWidth * 0.1),
                              child: Flag.fromCode(
                                FlagsCode.DO,
                                fit: BoxFit.fill,
                                height: 50,
                                width: 50,
                                borderRadius: 100,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: screenWidth * .4),
                              child: Container(
                                width: 50,
                                height: 50,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 5, top: 2),
                                  child: Image.asset("assets/changePhoto.png"),
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Color(0xff1db9fc),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width * .9,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(26),
                color: Color(0xff1b1b1b),
              ),
              child: Column(
                children: const [
                  Padding(
                    padding: EdgeInsets.only(
                        top: 0, left: 20, right: 20, bottom: 20),
                    child: Text(
                      "Jose Armando H.",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        letterSpacing: 2.10,
                      ),
                    ),
                  ),
                  Text(
                    "Una chica divertida, honesta y cool.\nNo tengo hijos y estoy buscando algo\nestable.",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5, top: 2),
                    child: SvgPicture.asset("assets/pencil.svg"),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Color(0xff1db9fc),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
