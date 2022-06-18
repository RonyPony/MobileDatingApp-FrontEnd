import 'dart:math';

import 'package:flag/flag_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:inlove/models/country.dart';
import 'package:inlove/models/user.dart';
import 'package:inlove/providers/auth_provider.dart';
import 'package:inlove/screens/login.page.dart';
import 'package:provider/provider.dart';
import '../controls/menu.dart';
import '../providers/countries_provider.dart';

class ProfileScreen extends StatefulWidget {
  static String routeName = '/ProfileScreen';

  const ProfileScreen({Key? key}) : super(key: key);
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<User> localUserInfo;

  @override
  void initState() {
    super.initState();
    Future<User> userInfo = getUserInfo();
    localUserInfo = userInfo;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width * 1;
    return Scaffold(
      bottomNavigationBar: const MainMenu(),
      backgroundColor: const Color(0xff020202),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xff020202),
        title: const Text('LoVers - Perfil'),
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
                    color: const Color(0xff1b1b1b),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 010, left: 10, right: 10, bottom: 10),
                        child: Image.asset(
                          "assets/man.png",
                          height: MediaQuery.of(context).size.height * .5,
                          width: MediaQuery.of(context).size.width * .9,
                        ),
                      ),
                      SizedBox(
                        // color: Colors.red,
                        height: 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FutureBuilder<User>(
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator(color: Colors.pink,);
                                }
                                if (snapshot.hasError) {
                                  return const Text("Err");
                                }

                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  if (snapshot.hasData) {
                                    Future<Country> pais = getCountry(
                                        "${snapshot.data?.countryId}");
                                    return FutureBuilder<Country>(
                                      future: pais,
                                      builder: (context, snapshotCountry) {
                                        if (snapshotCountry.hasData &&
                                            snapshotCountry.connectionState ==
                                                ConnectionState.done) {
                                          return 
                                          Flag.fromString(
                                            "${snapshotCountry. data?.code}",
                                            fit: BoxFit.fill,
                                            height: 50,
                                            width: 50,
                                            borderRadius: 100,
                                          );

                                          // Flag.fromCode(
                                          //   FlagsCode.CA,
                                          //   fit: BoxFit.fill,
                                          //   height: 50,
                                          //   width: 50,
                                          //   borderRadius: 100,
                                          // );
                                        }
                                        return const CircularProgressIndicator(
                                          color: Colors.pink,
                                        );
                                      },
                                    );
                                  }
                                  return const Text("Error 3");
                                }
                                return const Text("error 4");
                              },
                              future: localUserInfo,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: screenWidth * .4),
                              child: Container(
                                width: 50,
                                height: 50,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 5, top: 2),
                                  child: Image.asset("assets/changePhoto.png",),
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: const Color(0xff1db9fc),
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
                  FutureBuilder<User>(
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator(
                          color: Colors.pink,
                        );
                      }
                      if (snapshot.hasError) {
                        return const Text("Error obteniendo datos");
                      }
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData) {
                          if (snapshot.data?.bio == "N/A") {
                            snapshot.data?.bio =
                                "No has agregado informacion sobre ti, hazlo " +
                                    getAnEmmoji(false);
                          }
                          return Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 0, left: 20, right: 20, bottom: 20),
                                child: Text(
                                  "${snapshot.data?.name} ${snapshot.data?.lastName}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    letterSpacing: 2.10,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20,right: 20),
                                child: Text(
                                  "${snapshot.data?.bio}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          );
                        }
                        return const Text("No identificado");
                      }
                      return const Text("NO INFO");
                    },
                    future: localUserInfo,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
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
                    color: const Color(0xff1db9fc),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            logout(),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget logout() {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamedAndRemoveUntil(
            context, LoginPage.routeName, (route) => false);
      },
      child: Container(
        width: MediaQuery.of(context).size.width * .8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          color: const Color(0xff242424),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Text(
                "Cerrar Sesion",
                style: TextStyle(color: Colors.grey, fontSize: 22),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<User> getUserInfo() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    User currentUser = await authProvider.readLocalUserInfo();
    return currentUser;
  }

  String getAnEmmoji(bool cool) {
    var coolEmojies = ['😇', '🤩', '🥳', '😎', '😊'];
    var notCoolEmojies = ['🥺', '😕', '😅', '😩', '😢'];
    // generates a new Random object
    final _random = Random();
    String element;
    // generate a random index based on the list length
    // and use it to retrieve the element
    if (cool) {
      element = coolEmojies[_random.nextInt(coolEmojies.length)];
    } else {
      element = notCoolEmojies[_random.nextInt(notCoolEmojies.length)];
    }
    return element;
  }

  Future<Country> getCountry(String s) async {
    final authProvider = Provider.of<CountriesProvider>(context, listen: false);
    Country pais = await authProvider.findCountryById(s);
    return pais;
  }
}
