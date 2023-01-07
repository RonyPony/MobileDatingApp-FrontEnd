import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flag/flag_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inlove/providers/auth_provider.dart';
import 'package:inlove/screens/setting.page.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as fba;
import 'package:url_launcher/url_launcher.dart';
import '../helpers/dataInput.dart';
import '../helpers/emojies.dart';
import '../models/chat_arguments.dart';
import '../models/country.dart';
import '../models/photo.dart';
import '../models/sexual_orientations.dart';
import '../models/user.dart';
import '../providers/chat_provider.dart';
import '../providers/countries_provider.dart';
import '../providers/photo_provider.dart';
import 'conversation.page.dart';
import 'login.page.dart';

class UserProfileScreen extends StatefulWidget {
  static String routeName = "/UserProfileScreen";

  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _StateUserProfile();
}

class _StateUserProfile extends State<UserProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Future<User> _user;

  late Future<User> _currentUser;
  final ImagePicker _picker = ImagePicker();

  TextEditingController whatsCtr = TextEditingController();
  TextEditingController nameCtr = TextEditingController();
  TextEditingController lastNameCtr = TextEditingController();
  TextEditingController bioCtr = TextEditingController();
  String userName = "";
  String lastName = "";
  String bio = "";
  bool isBioEmpty = true;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _controller.repeat();
    super.initState();
    int? args;
    Future.delayed(Duration.zero, () {
      setState(() {
        args = ModalRoute.of(context)!.settings.arguments as int;
      });
      print(args);
      loadUser(args);
      Future<User> userInfo = getUserInfo(args);
      _currentUser = userInfo;
    });
  }

  @override
  Widget build(BuildContext context) {
    Future<Widget> profilePic = getUserImage(_currentUser);
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
                "Cargando...",
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
          backgroundColor: Colors.black,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: const Color(0xff020202),
            title: Text('LoVers - perfil'),
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
                              child: FutureBuilder<Widget>(
                                future: profilePic,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return CircularProgressIndicator(
                                        color: Colors.pink);
                                  }
                                  if (snapshot.hasError) {
                                    return Text("Error Occured");
                                  }
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    if (snapshot.hasData) {
                                      return snapshot.data!;
                                    }
                                  }
                                  return Text("Unknown error");
                                },
                              )),
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
                                        Future<Country> pais = getCountry(
                                            "${snapshot.data?.countryId}");
                                        return FutureBuilder<Country>(
                                          future: pais,
                                          builder: (context, snapshotCountry) {
                                            if (snapshotCountry.hasData &&
                                                snapshotCountry
                                                        .connectionState ==
                                                    ConnectionState.done) {
                                              int? sexOrId = snapshot
                                                  .data!.sexualOrientationId;
                                              final authProvider =
                                                  Provider.of<AuthProvider>(
                                                      context,
                                                      listen: false);
                                              Future<SexualOrientation> so =
                                                  authProvider
                                                      .getSexualOrientationById(
                                                          sexOrId!);
                                              return GestureDetector(
                                                onTap: () {
                                                  Navigator
                                                      .pushNamedAndRemoveUntil(
                                                          context,
                                                          SettingScreen
                                                              .routeName,
                                                          (route) => false);
                                                },
                                                child: Row(
                                                  children: [
                                                    Flag.fromString(
                                                      "${snapshotCountry.data?.code}",
                                                      fit: BoxFit.fill,
                                                      height: 50,
                                                      width: 50,
                                                      borderRadius: 100,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Container(
                                                          padding: EdgeInsets.only(
                                                              left: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  .2,
                                                              right: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  .2),
                                                          child: sexOrId != 0
                                                              ? FutureBuilder<
                                                                  SexualOrientation>(
                                                                  future: so,
                                                                  builder: (context,
                                                                      _sexualOrientation) {
                                                                    if (_sexualOrientation
                                                                            .connectionState ==
                                                                        ConnectionState
                                                                            .waiting) {
                                                                      return CircularProgressIndicator(
                                                                          color:
                                                                              Colors.pink);
                                                                    }
                                                                    if (_sexualOrientation
                                                                        .hasError) {
                                                                      return Text(
                                                                          "Err");
                                                                    }
                                                                    if (_sexualOrientation.connectionState ==
                                                                            ConnectionState
                                                                                .done &&
                                                                        _sexualOrientation
                                                                            .hasData) {
                                                                      final photoProv = Provider.of<
                                                                              PhotoProvider>(
                                                                          context,
                                                                          listen:
                                                                              false);
                                                                      int currentFlagImageId = _sexualOrientation
                                                                          .data!
                                                                          .imageId!;
                                                                      Future<Photo>
                                                                          flag =
                                                                          photoProv
                                                                              .getPhoto(currentFlagImageId);
                                                                      return FutureBuilder<
                                                                          Photo>(
                                                                        future:
                                                                            flag,
                                                                        builder:
                                                                            (context,
                                                                                _flag) {
                                                                          if (_flag.connectionState ==
                                                                              ConnectionState.waiting) {
                                                                            return CircularProgressIndicator(color: Colors.pink);
                                                                          }
                                                                          if (_flag
                                                                              .hasError) {
                                                                            return Text("Err");
                                                                          }
                                                                          if (_flag.connectionState == ConnectionState.done &&
                                                                              _flag.hasData) {
                                                                            return CircleAvatar(
                                                                              backgroundImage: MemoryImage(base64Decode(_flag.data!.image!)),
                                                                            );
                                                                          }
                                                                          return Text(
                                                                              "no data");
                                                                        },
                                                                      );
                                                                    }
                                                                    return Text(
                                                                        "no data 45");
                                                                  },
                                                                )
                                                              : SizedBox()),
                                                    ), //CircleAvatar
                                                  ],
                                                ),
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
                                  future: _currentUser,
                                ),
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
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator(
                              color: Colors.pink,
                            );
                          }
                          if (snapshot.hasError) {
                            return const Text("Error obteniendo datos");
                          }
                          Emojies emoji = Emojies();
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasData) {
                              if (snapshot.data?.bio == "N/A") {
                                isBioEmpty = true;
                                snapshot.data?.bio =
                                    "${snapshot.data?.name} todavia no ha escrito sobre su persona, preguntale tu ! " +
                                        emoji.getAnEmmoji(true);
                              }
                              return Column(
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          top: 0,
                                          left: 20,
                                          right: 20,
                                          bottom: 20),
                                      child: Text(
                                        "${capitalize(snapshot.data?.name)} ${capitalize(snapshot.data?.lastName)}",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 30,
                                          letterSpacing: 2.10,
                                        ),
                                      )),
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 20),
                                      child: Text(
                                        "${capitalize(snapshot.data?.bio)}",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                      )),
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          top: 30, left: 20, right: 20),
                                      child: Column(
                                        children: [
                                          // Text(
                                          //   "Correo Electronico: ${snapshot.data?.email}",
                                          //   style: const TextStyle(
                                          //     color: Colors.white,
                                          //     fontSize: 15,
                                          //   ),
                                          // ),
                                          // SizedBox(
                                          //   height: 10,
                                          // ),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                GestureDetector(
                                                  onTap: (){
                                                     _launchMailClient(snapshot.data!.email!);
                                                  },
                                                  child: Image.asset(
                                                    "assets/email.gif",
                                                    width: 70,
                                                    height: 70,
                                                  ),
                                                ),
                                                snapshot.data!
                                                        .instagramUserEnabled!
                                                    ? GestureDetector(
                                                        onTap: () {
                                                          openInstagram(snapshot
                                                              .data!
                                                              .instagramUser!.replaceAll("@", ""));
                                                        },
                                                        child: Image.asset(
                                                          "assets/instagram1.gif",
                                                          width: 80,
                                                          height: 80,
                                                        ),
                                                      )
                                                    : SizedBox(),
                                                // Text(
                                                //     "Instagram: ${snapshot.data?.instagramUser} (Oculto)",
                                                //     style: const TextStyle(
                                                //       color: Colors.white,
                                                //       fontSize: 15,
                                                //     ),
                                                //   ),

                                                snapshot.data!
                                                        .whatsappNumberEnabled!
                                                    ? GestureDetector(
                                                        onTap: () {
                                                          openwhatsapp(snapshot
                                                              .data!
                                                              .whatsappNumber!);
                                                        },
                                                        child: Image.asset(
                                                          "assets/whatsapp.gif",
                                                          width: 80,
                                                          height: 80,
                                                        ),
                                                      )
                                                    : SizedBox()
                                                // Text(
                                                //     "Whatsapp: ${snapshot.data?.whatsappNumber} (Oculto)",
                                                //     style: const TextStyle(
                                                //       color: Colors.white,
                                                //       fontSize: 15,
                                                //     ),
                                                //   )
                                              ]),
                                        ],
                                      )),
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
                        future: _currentUser,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                  height: 10,
                ),
                openChat(),
                const SizedBox(
                  height: 10,
                ),
                deleteMatch(),
                const SizedBox(
                  height: 60,
                ),
                blockUser(),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ));
  }

  openwhatsapp(String num) async {
    var whatsapp = num;
    String message = getRandomMessage();
    var whatsappURl_android =
        "whatsapp://send?phone=" + whatsapp + "&text=" + message;
    var whatappURL_ios = "https://wa.me/$whatsapp?text=${Uri.parse("hello")}";
    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunch(whatappURL_ios)) {
        await launch(whatappURL_ios, forceSafariVC: false);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: new Text("whatsapp no installed")));
      }
    } else {
      // android , web
      if (await canLaunch(whatsappURl_android)) {
        await launch(whatsappURl_android);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: new Text("whatsapp no installed")));
      }
    }
  }

  void _launchMailClient(String kEmail) async {
    String mailUrl = 'mailto:$kEmail';
    try {
      await launch(mailUrl);
    } catch (e) {
      print(e);
      // await Clipboard.setData(ClipboardData(text: '$kEmail'));
      // _emailCopiedToClipboard = true;
    }
  }

  Widget openChat() {
    return GestureDetector(
      onTap: () async {
        final chatProvider = Provider.of<ChatProvider>(context, listen: false);
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        User _currentUser = await authProvider.readLocalUserInfo();

        var instance = fba.FirebaseAuth.instance;
        String _uid = instance.currentUser!.uid;

        String currentUserId = _currentUser.id.toString();
        User user = await _user;
        String secondID = await user.id.toString();
        String uid = await authProvider.getFirebaseUidByEmail(user.email!);
        String secondUID = uid;
        print("Waiting 1 sec");
        await Future.delayed(Duration(seconds: 1), () {});
        print("Creating room");

        String roomId = chatProvider.createRoom(_uid, currentUserId, secondUID,
            secondID, "[${user.name} ${user.lastName}]|[${_currentUser.name} ${_currentUser.lastName}]");
        ChatArguments args = ChatArguments(user, roomId);
        Navigator.pushNamed(context, Conversation.routeName, arguments: args);
        // Navigator.pushNamed(context, UserProfileScreen.routeName,
        //     arguments: usuario.id);
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
                "Conversar",
                style: TextStyle(color: Colors.blue, fontSize: 22),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget deleteMatch() {
    return Container(
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
              "Eliminar Match",
              style: TextStyle(color: Colors.grey, fontSize: 22),
            ),
          ),
        ],
      ),
    );
  }

  Widget blockUser() {
    return Container(
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
              "Bloquear",
              style: TextStyle(color: Colors.red, fontSize: 22),
            ),
          ),
        ],
      ),
    );
  }

  Future<Widget> getUserImage(Future<User?> data) async {
    final photoProvider = Provider.of<PhotoProvider>(context, listen: false);
    User? usuario = await data;
    Photo userPhoto = await photoProvider.getUserProfilePicture(usuario!.id!);
    if (userPhoto.image == null) {
      return Image.asset(
        "assets/placeHolder.png",
        height: MediaQuery.of(context).size.height * .5,
        width: MediaQuery.of(context).size.width * .9,
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          // border: Border.all(width: 2)
        ),
        child: Image.memory(
          base64Decode(userPhoto.image!),
          height: MediaQuery.of(context).size.height * .5,
          width: MediaQuery.of(context).size.width * .9,
        ),
      );
    }
  }

  Future<Country> getCountry(String s) async {
    final authProvider = Provider.of<CountriesProvider>(context, listen: false);
    Country pais = await authProvider.findCountryById(s);
    return pais;
  }

  void loadUser(userId) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    Future<User> usr = authProvider.findUserById(userId);
    _user = usr;
  }

  Widget _buildNameEditField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding:
              const EdgeInsets.only(left: 20, top: 16, bottom: 16, right: 20),
          child: TextField(
            controller: nameCtr,
            // autofocus: true,
            onChanged: (x) {
              // if (x.length >= 10) {
              //   profileInfoChanged=true;
              //   setState(() {});
              // }
              // if (x.length == 0) {
              //   profileInfoChanged=false;
              //   setState(() {});
              // }
            },
            cursorColor: Colors.black,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              fillColor: const Color(0xfc616161),
              filled: true,
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(20)),
              hintText: userName.length >= 1 ? userName : "Nombre",
            ),
          ),
        ),
        // Padding(
        //     padding: EdgeInsets.only(
        //         left: MediaQuery.of(context).size.width * .3, bottom: 10),
        //     child: Visibility(
        //       visible: profileInfoChanged,
        //       child: ElevatedButton.icon(
        //         onPressed: () async {
        //           final settings =
        //               Provider.of<SettingsProvider>(context, listen: false);
        //           final userProv =
        //               Provider.of<AuthProvider>(context, listen: false);
        //           User currentUser = await userProv.read_currentUser();
        //           var igSetted = await settings.setWhatsapp(
        //               currentUser.id!, whatsCtr.text);
        //           if (igSetted) {
        //             profileInfoChanged= false;
        //             setState(() {});
        //           }
        //         },
        //         icon: Icon(Icons.save_rounded, size: 18),
        //         label: Text("GUARDAR WHATSAPP"),
        //       ),
        //     ))
      ],
    );
  }

  Widget _buildLastNameEditField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding:
              const EdgeInsets.only(left: 20, top: 16, bottom: 16, right: 20),
          child: TextField(
            controller: lastNameCtr,
            onChanged: (x) {},
            cursorColor: Colors.black,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              fillColor: const Color(0xfc616161),
              filled: true,
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(20)),
              hintText: lastName.length >= 1 ? lastName : "Apellido",
            ),
          ),
        ),
      ],
    );
  }

  Future<User> getUserInfo(int? id) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    User currentUser = await authProvider.findUserById(id!);
    userName = currentUser.name!;
    lastName = currentUser.lastName!;
    bio = currentUser.bio!;
    isBioEmpty = currentUser.bio == "N/A";
    return currentUser;
  }

  Widget _buildBioEditField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 20, top: 16, bottom: 16, right: 20),
          child: TextField(
            controller: bioCtr,
            onChanged: (x) {},
            cursorColor: Colors.black,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              fillColor: const Color(0xfc616161),
              filled: true,
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(20)),
              hintText: bio.length >= 1 && !isBioEmpty ? bio : "Sobre ti",
            ),
          ),
        ),
      ],
    );
  }

  getRandomMessage() {
    var preLoadedMessages = [
      'El amor sera ciego, pero hay que ver lo mucho que alegras la vista.',
      'Con esos ojos mirandome, ya no me hace falta la luz del sol.',
      'Por la luna daria un beso, daria todo por el sol, pero por la luz de tu mirada, doy mi vida y corazon.',
      'Si yo fuera un avion y tu un aeropuerto, me la pasaria aterrizando por tu hermoso cuerpo.',
      'Tantas estrellas en el espacio y ninguna brilla como tu.',
      'Me gusta el cafe, pero prefiero tener-te.',
      'No eres Google, pero tienes todo lo que yo busco',
      'Te regalo esta flor, aunque ninguna sera jamás tan bella como tu',
      'Cuando te multen por exceso de belleza, yo pagare tu fianza.'
    ];
    // generates a new Random object
    final _random = Random();
    String msg = preLoadedMessages[_random.nextInt(preLoadedMessages.length)]
        .replaceAll(" ", "%20")
        .replaceAll(",", "")
        .replaceAll(".", "");
    return msg;
  }

  void openInstagram(String user) async {
    var url = 'https://www.instagram.com/'+user+'/';

    if (await canLaunch(url)) {
      await launch(
        url,
        universalLinksOnly: true,
      );
    } else {
      throw 'There was a problem to open the url: $url';
    }
  }
}
