import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flag/flag_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inlove/controls/menu.dart';
import 'package:inlove/models/photo.dart';
import 'package:inlove/providers/auth_provider.dart';
import 'package:inlove/providers/match_provider.dart';
import 'package:inlove/providers/photo_provider.dart';
import 'package:inlove/screens/setting.page.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

import '../helpers/emojies.dart';
import '../models/country.dart';
import '../models/sexual_orientations.dart';
import '../models/user.dart';
import '../providers/countries_provider.dart';

class HomePage extends StatefulWidget {
  static String routeName = "/homePage";

  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<User> _usuario;
  int _userId = 0;
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
                CircularProgressIndicator(color: Colors.pink),
              ],
            );
          }
          if (snapshot.hasError) {
            return Text("Error ${snapshot.error.toString()}");
          }
          Emojies emoji = Emojies();
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            if (snapshot.data!.hasError!) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      color: Colors.red,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              snapshot.data!.error!,
                              style: TextStyle(color: Colors.white),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: ElevatedButton(
                                onPressed: () {
                                  //TODO report implementation
                                },
                                child: Text('Reportalo'),
                              ),
                            )
                          ],
                        ),
                      )),
                ],
              );
            }
            Future<Widget> profilePic = getUserImage(snapshot.data);
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
                                  top: 010, left: 10, right: 10, bottom: 0),
                              child: FutureBuilder<Widget>(
                                future: profilePic,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return CircularProgressIndicator(
                                        color: Colors.pink);
                                  } else {
                                    if (snapshot.hasError) {
                                      return Text("Error found");
                                    }
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      if (snapshot.hasData) {
                                        return snapshot.data!;
                                      }
                                      return Text("no data error");
                                    }
                                  }
                                  return Text("unknown error");
                                },
                              )
                              // Image.asset(
                              //   "assets/placeHolder.png",
                              //   height: MediaQuery.of(context).size.height * .5,
                              //   width: MediaQuery.of(context).size.width * .9,
                              // ),
                              ),
                          FutureBuilder<User>(
                            future: _usuario,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator(
                                    color: Colors.pink);
                              }
                              if (snapshot.hasError) {
                                return Text("Error Ocurred");
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                if (snapshot.hasData) {
                                  Future<String> countryCode =
                                      getCountryCode(snapshot.data!.countryId);
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            FutureBuilder<User>(
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return const CircularProgressIndicator(
                                                    color: Colors.pink,
                                                  );
                                                }
                                                if (snapshot.hasError) {
                                                  return const Text("Err");
                                                }

                                                if (snapshot.connectionState ==
                                                    ConnectionState.done) {
                                                  if (snapshot.hasData) {
                                                    Future<Country> pais =
                                                        getCountry(
                                                            "${snapshot.data?.countryId}");
                                                    return FutureBuilder<
                                                        Country>(
                                                      future: pais,
                                                      builder: (context,
                                                          snapshotCountry) {
                                                        if (snapshotCountry
                                                                .hasData &&
                                                            snapshotCountry
                                                                    .connectionState ==
                                                                ConnectionState
                                                                    .done) {
                                                          int? sexOrId = snapshot
                                                              .data!
                                                              .sexualOrientationId;
                                                          final authProvider =
                                                              Provider.of<
                                                                      AuthProvider>(
                                                                  context,
                                                                  listen:
                                                                      false);
                                                          Future<SexualOrientation>
                                                              so = authProvider
                                                                  .getSexualOrientationById(
                                                                      sexOrId!);
                                                          return Row(
                                                            children: [
                                                              GestureDetector(
                                                                onTap: () {
                                                                  CoolAlert.show(
                                                                      context:
                                                                          context,
                                                                      type: CoolAlertType
                                                                          .info,
                                                                      backgroundColor:
                                                                          Colors
                                                                              .white,
                                                                      loopAnimation:
                                                                          false,
                                                                          cancelBtnText: "Configurar mi pais",
                                                                          showCancelBtn: true,
                                                                          onCancelBtnTap: (){
                                                                            Navigator.pushNamedAndRemoveUntil(
                                                                            context,
                                                                            SettingScreen
                                                                                .routeName,
                                                                            (route) =>
                                                                                false);
                                                                          },
                                                                      title: snapshotCountry.data!.name!,
                                                                      text:
                                                                          '${snapshot.data!.name!} ${snapshot.data!.lastName!} ha seleccionado su pais como ${snapshotCountry.data!.name}');
                                                                  
                                                                },
                                                                child: Flag
                                                                    .fromString(
                                                                  "${snapshotCountry.data?.code}",
                                                                  fit: BoxFit
                                                                      .fill,
                                                                  height: 50,
                                                                  width: 50,
                                                                  borderRadius:
                                                                      100,
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child: Container(
                                                                    padding: EdgeInsets.only(),
                                                                    child: sexOrId != 0
                                                                        ? FutureBuilder<SexualOrientation>(
                                                                            future:
                                                                                so,
                                                                            builder:
                                                                                (context, _sexualOrientation) {
                                                                              if (_sexualOrientation.connectionState == ConnectionState.waiting) {
                                                                                return CircularProgressIndicator(color:Colors.pink);
                                                                              }
                                                                              if (_sexualOrientation.hasError) {
                                                                                return Text("Err");
                                                                              }
                                                                              if (_sexualOrientation.connectionState == ConnectionState.done && _sexualOrientation.hasData) {
                                                                                final photoProv = Provider.of<PhotoProvider>(context, listen: false);
                                                                                int currentFlagImageId = _sexualOrientation.data!.imageId!;
                                                                                Future<Photo> flag = photoProv.getPhoto(currentFlagImageId);
                                                                                return FutureBuilder<Photo>(
                                                                                  future: flag,
                                                                                  builder: (context, _flag) {
                                                                                    if (_flag.connectionState == ConnectionState.waiting) {
                                                                                      return CircularProgressIndicator(color:Colors.pink);
                                                                                    }
                                                                                    if (_flag.hasError) {
                                                                                      return Text("Err");
                                                                                    }
                                                                                    if (_flag.connectionState == ConnectionState.done && _flag.hasData) {
                                                                                      return GestureDetector(
                                                                                        onTap: () {
                                                                                          CoolAlert.show(
                                                                                            context: context,
                                                                                             type: CoolAlertType.info,
                                                                                             backgroundColor: Colors.white,
                                                                                             loopAnimation: false,
                                                                                             title: _sexualOrientation.data!.name!,                                                    
                                                                                             text: '${snapshot.data!.name!} ${snapshot.data!.lastName!} ha seleccionado su sexualidad como ${_sexualOrientation.data!.name}');
                                                                                        },
                                                                                        child: CircleAvatar(
                                                                                          backgroundImage: MemoryImage(base64Decode(_flag.data!.image!)),
                                                                                        ),
                                                                                      );
                                                                                    }
                                                                                    return Text("no data");
                                                                                  },
                                                                                );
                                                                              }
                                                                              return Text("no data 45");
                                                                            },
                                                                          )
                                                                        : SizedBox()),
                                                              ), //CircleAvatar
                                                            ],
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
                                              future: _usuario,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                    ],
                                  );
                                }
                                return Text("Error 3320");
                              }
                              return Text("Error 455");
                            },
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
                          "${snapshot.data!.name} ${snapshot.data!.lastName}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            letterSpacing: 2.10,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 0, bottom: 8, left: 10, right: 10),
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
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            snapshot.data!.instagramUserEnabled!
                                ? SvgPicture.asset(
                                    'assets/instagram.svg',
                                    color: Colors.white,
                                    height: 18,
                                  )
                                : SizedBox(),
                            snapshot.data!.instagramUserEnabled!
                                ? Text(
                                    " ${snapshot.data!.instagramUser!}",
                                    style: TextStyle(color: Colors.white),
                                  )
                                : SizedBox(),
                            SizedBox(
                              width: 10,
                            ),
                            snapshot.data!.whatsappNumberEnabled!
                                ? SvgPicture.asset(
                                    'assets/whatsapp.svg',
                                    color: Colors.white,
                                    height: 18,
                                  )
                                : SizedBox(),
                            snapshot.data!.whatsappNumberEnabled!
                                ? Text(
                                    " ${snapshot.data!.whatsappNumber!}",
                                    style: TextStyle(color: Colors.white),
                                  )
                                : SizedBox(),
                          ],
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
                        bool created = await matchProvider.createMatch(
                            currentUser.id!, _userId);
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
      print("Getting Possible Match of "+currentUser.name!+" ID: "+currentUser.id!.toString());
      User possibleMatch =
          await matchProvider.getPossibleMatch(currentUser.id!);

      if (possibleMatch.hasError!) {
        CoolAlert.show(
            context: context,
            animType: CoolAlertAnimType.slideInDown,
            backgroundColor: Colors.white,
            loopAnimation: false,
            type: CoolAlertType.error,
            text: possibleMatch.error,
            title: "Algo salio mal. Pero chill, intenta de nuevo 🤪");
      } else {
        _userId = possibleMatch.id!;
        return possibleMatch;
      }
      return possibleMatch;
    } catch (e) {
      print(e);
      return User();
    }
  }

  Future<Widget> getUserImage(User? data) async {
    final photoProvider = Provider.of<PhotoProvider>(context, listen: false);
    Photo userPhoto = await photoProvider.getUserProfilePicture(data!.id!);
    if (userPhoto.image == null) {
      return Image.asset(
        "assets/placeHolder.png",
        height: MediaQuery.of(context).size.height * .5,
        width: MediaQuery.of(context).size.width * .9,
      );
    } else {
      return Image.memory(
        base64Decode(userPhoto.image!),
        height: MediaQuery.of(context).size.height * .5,
        width: MediaQuery.of(context).size.width * .9,
      );
    }
  }

  Future<Country> getCountry(String s) async {
    final authProvider = Provider.of<CountriesProvider>(context, listen: false);
    Country pais = await authProvider.findCountryById(s);
    return pais;
  }

  Future<String> getCountryCode(int? countryId) async {
    if (countryId == 0) {
      return "NULL";
    }
    final authProvider = Provider.of<CountriesProvider>(context, listen: false);
    Country pais = await authProvider.findCountryById('$countryId');
    return pais.code!;
  }
}
