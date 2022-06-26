import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inlove/controls/menu.dart';
import 'package:inlove/providers/auth_provider.dart';
import 'package:inlove/providers/match_provider.dart';
import 'package:provider/provider.dart';

import '../helpers/emojies.dart';
import '../models/user.dart';

class HomePage extends StatefulWidget {
  static String routeName = "/homePage";

  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<User> _usuario;
  int _userId=0;
  @override
  void initState() {
    _usuario = getPossibleMatch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const MainMenu(),
      backgroundColor: const Color(0xff020202),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xff020202),
        title: const Text('LoVers'),
      ),
      body: SingleChildScrollView(
          child: FutureBuilder<User>(
        future: _usuario,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.none) {
            return Icon(
              Icons.close,
              color: Colors.white,
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
              ],
            );
          }
          if (snapshot.hasError) {
            return Text("Error ${snapshot.error.toString()}");
          }
          Emojies emoji = Emojies();
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return Column(
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
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 010, left: 10, right: 10, bottom: 10),
                            child: Image.asset(
                              "assets/placeHolder.png",
                              height: MediaQuery.of(context).size.height * .5,
                              width: MediaQuery.of(context).size.width * .9,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * .9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(26),
                    color: const Color(0xff1b1b1b),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: 0, left: 20, right: 20, bottom: 20),
                        child: Text(
                          "${snapshot.data!.name!} ${snapshot.data!.lastName}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            letterSpacing: 2.10,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Text(
                          snapshot.data!.bio != "N/A"
                              ? snapshot.data!.bio!
                              : "Aun no ha agregado informacion sobre el " +
                                  emoji.getAnEmmoji(false),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (kDebugMode) {
                          print("DENY");
                        }
                        setState(() {
                          _usuario = getPossibleMatch();
                        });
                      },
                      child: Container(
                          width: 88,
                          height: 90,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xff1db9fc),
                          ),
                          child: SvgPicture.asset("assets/deny.svg")),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () async {
                        final matchProvider =
                            Provider.of<MatchProvider>(context, listen: false);
                        final authProvider =
                            Provider.of<AuthProvider>(context, listen: false);
                        User currentUser =
                            await authProvider.readLocalUserInfo();
                        bool created = await matchProvider.createMatch(currentUser.id!, _userId);
                        setState(() {
                          _usuario = getPossibleMatch();
                        });
                        if (kDebugMode) {
                          print("ACEPTED");
                        }
                      },
                      child: Container(
                        width: 88,
                        height: 90,
                        child: Image.asset(
                          "assets/love3.png",
                          // color: Color.fromARGB(255, 212, 2, 54),
                        ),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xff1db9fc),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            );
          }
          return Text("No Info");
        },
      )),
    );
  }

  Future<User> getPossibleMatch() async {
    try {
      final matchProvider = Provider.of<MatchProvider>(context, listen: false);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      User currentUser = await authProvider.readLocalUserInfo();
      User possibleMatch = await matchProvider.getPossibleMatch(currentUser.id!);
      _userId = possibleMatch.id!;
      return possibleMatch;
    } catch (e) {
      print(e);
      return User();
    }
  }
}
