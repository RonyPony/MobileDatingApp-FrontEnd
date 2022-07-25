import 'dart:convert';
import 'dart:math';

import 'package:cool_alert/cool_alert.dart';
import 'package:flag/flag_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inlove/providers/auth_provider.dart';
import 'package:inlove/screens/setting.page.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

import '../helpers/emojies.dart';
import '../models/country.dart';
import '../models/photo.dart';
import '../models/photoToUpload.dart';
import '../models/sexual_orientations.dart';
import '../models/user.dart';
import '../providers/countries_provider.dart';
import '../providers/photo_provider.dart';
import 'login.page.dart';

class UserProfileScreen extends StatefulWidget {
  static String routeName = "/UserProfileScreen";

  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _StateUserProfile();
  
}

class _StateUserProfile extends State<UserProfileScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Future<User>_user;

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
    Future<Widget> profilePic = getUserImage(_currentUser!);
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
      child:Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xff020202),
          title:  Text('LoVers - perfil'),
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
                                  return CircularProgressIndicator(color:Colors.pink);
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
                                              snapshotCountry.connectionState ==
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
                                                        SettingScreen.routeName,
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
                                                      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*.2,right: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                .2),
                                                        child: sexOrId!=0?FutureBuilder<
                                                            SexualOrientation>(
                                                      future: so,
                                                      builder: (context,
                                                          _sexualOrientation) {
                                                        if (_sexualOrientation
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          return CircularProgressIndicator(color:Colors.pink);
                                                        }
                                                        if (_sexualOrientation
                                                            .hasError) {
                                                          return Text("Err");
                                                        }
                                                        if (_sexualOrientation
                                                                    .connectionState ==
                                                                ConnectionState
                                                                    .done &&
                                                            _sexualOrientation
                                                                .hasData) {
                                                          final photoProv = Provider
                                                              .of<PhotoProvider>(
                                                                  context,
                                                                  listen:
                                                                      false);
                                                          int currentFlagImageId =
                                                              _sexualOrientation
                                                                  .data!
                                                                  .imageId!;
                                                          Future<Photo> flag =
                                                              photoProv.getPhoto(
                                                                  currentFlagImageId);
                                                          return FutureBuilder<
                                                              Photo>(
                                                            future: flag,
                                                            builder: (context,
                                                                _flag) {
                                                              if (_flag
                                                                      .connectionState ==
                                                                  ConnectionState
                                                                      .waiting) {
                                                                return CircularProgressIndicator(color:Colors.pink);
                                                              }
                                                              if (_flag
                                                                  .hasError) {
                                                                return Text(
                                                                    "Err");
                                                              }
                                                              if (_flag.connectionState ==
                                                                      ConnectionState
                                                                          .done &&
                                                                  _flag
                                                                      .hasData) {
                                                                return CircleAvatar(
                                                                  backgroundImage:MemoryImage(base64Decode(_flag
                                                                          .data!
                                                                          .image!)),
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
                                                    ):SizedBox()),
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
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            if (snapshot.data?.bio == "N/A") {
                              isBioEmpty = true;
                              snapshot.data?.bio =
                                  "No has agregado informacion sobre ti, hazlo " +
                                      emoji.getAnEmmoji(false);
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
                                        )
                                      
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20),
                                    child: Text(
                                            "${snapshot.data?.bio}",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                            ),
                                          )
                                       ),
                                Padding(
                                    padding: const EdgeInsets.only(
                                        top: 30, left: 20, right: 20),
                                    child: Column(
                                            children: [
                                              Text(
                                                "Correo Electronico: ${snapshot.data?.email}",
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              snapshot.data!
                                                      .instagramUserEnabled!
                                                  ? Text(
                                                      "Instagram: ${snapshot.data?.instagramUser}",
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15,
                                                      ),
                                                    )
                                                  : Text(
                                                      "Instagram: ${snapshot.data?.instagramUser} (Oculto)",
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              snapshot.data!
                                                      .whatsappNumberEnabled!
                                                  ? Text(
                                                      "Whatsapp: ${snapshot.data?.whatsappNumber}",
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15,
                                                      ),
                                                    )
                                                  : Text(
                                                      "Whatsapp: ${snapshot.data?.whatsappNumber} (Oculto)",
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15,
                                                      ),
                                                    )
                                            ],
                                          )
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
            ],
          ),
        ),
      )
    );
  }
  Widget openChat() {
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
                "Conversar",
                style: TextStyle(color: Colors.grey, fontSize: 22),
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
    final authProvider = Provider.of<AuthProvider>(context,listen: false);
    Future<User>usr = authProvider.findUserById(userId);
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


}
