import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:cool_alert/cool_alert.dart';
import 'package:flag/flag_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inlove/models/country.dart';
import 'package:inlove/models/photoToUpload.dart';
import 'package:inlove/models/sexual_orientations.dart';
import 'package:inlove/models/user.dart';
import 'package:inlove/providers/auth_provider.dart';
import 'package:inlove/screens/login.page.dart';
import 'package:inlove/screens/setting.page.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import '../controls/menu.dart';
import '../helpers/dataInput.dart';
import '../models/photo.dart';
import '../providers/countries_provider.dart';
import '../helpers/emojies.dart';
import '../providers/photo_provider.dart';

class ProfileScreen extends StatefulWidget {
  static String routeName = '/ProfileScreen';

  const ProfileScreen({Key? key}) : super(key: key);
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Future<User> localUserInfo;
  final ImagePicker _picker = ImagePicker();
  var editMode = false;

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
    Future<User> userInfo = getUserInfo();
    localUserInfo = userInfo;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width * 1;
    Future<Widget> profilePic = getUserImage(localUserInfo);
    return LoaderOverlay(
      useDefaultLoading: false,
      overlayWidgetBuilder: ((progress) {
        return Center(
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
                "Subiendo tu foto...",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                    decoration: TextDecoration.none),
              )
            ],
          ),
        ));
      }),
      child: Scaffold(
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
                                                    height: 60,
                                                    width: 60,
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
                                                                .1,
                                                            right: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                .1),
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
                                                                        color: Colors
                                                                            .pink);
                                                                  }
                                                                  if (_sexualOrientation
                                                                      .hasError) {
                                                                    return Text(
                                                                        "Err");
                                                                  }
                                                                  if (_sexualOrientation
                                                                              .connectionState ==
                                                                          ConnectionState
                                                                              .done &&
                                                                      _sexualOrientation
                                                                          .hasData) {
                                                                    final photoProv = Provider.of<
                                                                            PhotoProvider>(
                                                                        context,
                                                                        listen:
                                                                            false);
                                                                    int currentFlagImageId =
                                                                        _sexualOrientation
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
                                                                          return CircularProgressIndicator(
                                                                              color: Colors.pink);
                                                                        }
                                                                        if (_flag
                                                                            .hasError) {
                                                                          return Text(
                                                                              "Err");
                                                                        }
                                                                        if (_flag.connectionState ==
                                                                                ConnectionState.done &&
                                                                            _flag.hasData) {
                                                                          return Container(
                                                                            height:
                                                                                70,
                                                                            child:
                                                                                CircleAvatar(
                                                                              backgroundImage: MemoryImage(base64Decode(_flag.data!.image!)),
                                                                            ),
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
                                future: localUserInfo,
                              ),
                              Padding(
                                padding: EdgeInsets.only(),
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    // child: Image.asset("assets/changePhoto.png",),
                                    child: GestureDetector(
                                      onTap: () async {
                                        // final XFile? image =
                                        //     await _picker.pickImage(
                                        //         source: ImageSource.gallery);
                                        try {
                                          FocusScope.of(context).unfocus();
                                          context.loaderOverlay.show();
                                          final userProvider =
                                              Provider.of<AuthProvider>(context,
                                                  listen: false);
                                          final photoProvider =
                                              Provider.of<PhotoProvider>(
                                                  context,
                                                  listen: false);
                                          User currentUser = await userProvider
                                              .readLocalUserInfo();
                                          ImagePicker imagePicker =
                                              ImagePicker();
                                          final imageFile =
                                              await imagePicker.pickImage(
                                                  source: ImageSource.gallery,
                                                  imageQuality: 25);
                                          // File imagen = File(imageFile!.path);
                                          // String fileExt = getFileExtension(imagen.path);
                                          // String fileRoute = getFileRoute(imagen.path);
                                          // File compressed =await
                                          //     photoProvider.compressImage(
                                          //         imagen, fileRoute+"2"+fileExt);
                                          PhotoToUpload photoToUpload =
                                              PhotoToUpload();
                                          photoToUpload.image = imageFile!.path;
                                          photoToUpload.userId = currentUser.id;
                                          bool uploaded = await photoProvider
                                              .uploadPhoto(photoToUpload);
                                          if (uploaded) {
                                            CoolAlert.show(
                                                context: context,
                                                animType: CoolAlertAnimType
                                                    .slideInDown,
                                                backgroundColor: Colors.white,
                                                loopAnimation: false,
                                                type: CoolAlertType.success,
                                                title: "Completado",
                                                text:
                                                    "Se ha completado la carga de la imagen 📷");
                                          }
                                          context.loaderOverlay.hide();
                                          setState(() {});
                                        } catch (e) {
                                          CoolAlert.show(
                                              context: context,
                                              animType:
                                                  CoolAlertAnimType.slideInDown,
                                              backgroundColor: Colors.white,
                                              loopAnimation: false,
                                              type: CoolAlertType.error,
                                              title: "Ups!",
                                              text: e.toString());
                                          setState(() {});
                                        } finally {
                                          context.loaderOverlay.hide();
                                          setState(() {});
                                        }
                                      },
                                      child: SvgPicture.asset(
                                        "assets/changePhoto.svg",
                                        height: 50,
                                      ),
                                    ),
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
                                  child: !editMode
                                      ? Text(
                                          "${capitalize(snapshot.data?.name!)} ${snapshot.data?.lastName}",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 30,
                                            letterSpacing: 2.10,
                                          ),
                                        )
                                      : Column(
                                          children: [
                                            _buildNameEditField(),
                                            _buildLastNameEditField(),
                                          ],
                                        ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20),
                                    child: !editMode
                                        ? Text(
                                            "${capitalize(snapshot.data?.bio)}",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                            ),
                                          )
                                        : _buildBioEditField()),
                                Padding(
                                    padding: const EdgeInsets.only(
                                        top: 30, left: 20, right: 20),
                                    child: !editMode
                                        ? Column(
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
                                        : SizedBox()),
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
                  !editMode
                      ? GestureDetector(
                          onTap: () {
                            setState(() {
                              editMode = true;
                            });
                          },
                          child: Container(
                              height: 90,
                              width: 90,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: const Color(0xff1db9fc),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SvgPicture.asset(
                                  "assets/pencil2.svg",
                                  width: 50,
                                  height: 50,
                                ),
                              )),
                        )
                      : GestureDetector(
                          onTap: () {
                            setState(() {
                              editMode = false;
                            });
                          },
                          child: GestureDetector(
                            onTap: () async {
                              final userProvider = Provider.of<AuthProvider>(
                                  context,
                                  listen: false);
                              User currentUser =
                                  await userProvider.readLocalUserInfo();
                              if (nameCtr.text == "" || nameCtr.text == " ") {
                                nameCtr.text = userName;
                              }
                              if (lastNameCtr.text == "" ||
                                  lastNameCtr.text == " ") {
                                lastNameCtr.text = lastName;
                              }
                              if (bioCtr.text == "" || bioCtr.text == " ") {
                                bioCtr.text = bio;
                              }

                              currentUser.name = nameCtr.text;
                              currentUser.lastName = lastNameCtr.text;
                              currentUser.bio = bioCtr.text;
                              if (currentUser.name!.length <= 15 &&
                                  currentUser.lastName!.length <= 30) {
                                bool updated = await userProvider
                                    .updateUserInfo(currentUser);
                                if (updated) {
                                  bool updated2 = await userProvider
                                      .saveLocalUserInfoUser(currentUser);

                                  setState(() {
                                    editMode = false;
                                  });
                                  CoolAlert.show(
                                      context: context,
                                      animType: CoolAlertAnimType.slideInDown,
                                      backgroundColor: Colors.white,
                                      loopAnimation: false,
                                      onConfirmBtnTap: () {
                                        Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            ProfileScreen.routeName,
                                            (route) => false);
                                      },
                                      type: CoolAlertType.success,
                                      title: "Actualizado 👍🏼");
                                }
                              } else {
                                CoolAlert.show(
                                    context: context,
                                    animType: CoolAlertAnimType.slideInDown,
                                    backgroundColor: Colors.white,
                                    loopAnimation: false,
                                    type: CoolAlertType.warning,
                                    title:
                                        "Por favor ingrese un nombre y un apellido mas corto👍🏼");
                              }
                            },
                            child: Container(
                              width: 80,
                              height: 80,
                              child: const Padding(
                                padding: EdgeInsets.only(left: 5, top: 2),
                                child: Icon(Icons.save_as_rounded,
                                    color: Colors.white, size: 50),
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: const Color(0xff1db9fc),
                              ),
                            ),
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
              deleteAccount()
            ],
          ),
        ),
      ),
    );
  }

  Widget deleteAccount() {
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
              "Elimina mi cuenta",
              style: TextStyle(color: Colors.red, fontSize: 22),
            ),
          ),
        ],
      ),
    );
  }

  Widget logout() {
    return GestureDetector(
      onTap: () async {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        bool response = await authProvider.logout();
        if (response) {
          Navigator.pushNamedAndRemoveUntil(
              context, LoginPage.routeName, (route) => false);
        }
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
    userName = currentUser.name!;
    lastName = currentUser.lastName!;
    bio = currentUser.bio!;
    isBioEmpty = currentUser.bio == "N/A";
    return currentUser;
  }

  Future<Country> getCountry(String s) async {
    final authProvider = Provider.of<CountriesProvider>(context, listen: false);
    Country pais = await authProvider.findCountryById(s);
    return pais;
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
        //           User currentUser = await userProv.readLocalUserInfo();
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

  Widget _buildBioEditField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 20, top: 16, bottom: 16, right: 20),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 200,
            child: SizedBox(
              height: MediaQuery.of(context).size.width * 0.1377,
              child: TextFormField(
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
                enabled: true,
                expands: true,
                maxLines: null,
                minLines: null,
              ),
            ),
            // TextField(
            //   controller: bioCtr,
            //   onChanged: (x) {},
            //   cursorColor: Colors.black,
            //   style: const TextStyle(color: Colors.white),
            //   decoration: InputDecoration(
            //     fillColor: const Color(0xfc616161),
            //     filled: true,
            //     border: OutlineInputBorder(
            //         borderSide: BorderSide.none,
            //         borderRadius: BorderRadius.circular(20)),
            //     hintText: bio.length >= 1 && !isBioEmpty ? bio : "Sobre ti",
            //   ),
            // ),
          ),
        ),
      ],
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
      return Image.memory(
        base64Decode(userPhoto.image!),
        height: MediaQuery.of(context).size.height * .5,
        width: MediaQuery.of(context).size.width * .9,
      );
    }
  }

  String getFileExtension(String fileName) {
    try {
      String filename = fileName.split('.').first;
      String ext = "." + fileName.split('.').last;
      return ext;
    } catch (e) {
      return "";
    }
  }

  String getFileRoute(String fileName) {
    try {
      String filename = fileName.substring(2, 4);
      return filename;
    } catch (e) {
      return "";
    }
  }
}
