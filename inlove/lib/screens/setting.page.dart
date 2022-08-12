// ignore_for_file: constant_identifier_names

import 'dart:math';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:inlove/models/country.dart';
import 'package:inlove/models/user.dart';
import 'package:inlove/providers/countries_provider.dart';
import 'package:inlove/providers/settings_provider.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

import '../controls/menu.dart';
import '../controls/picker.dart';
import '../controls/range_select.dart';
import '../models/sexual_orientations.dart';
import '../providers/auth_provider.dart';

class SettingScreen extends StatefulWidget {
  static String routeName = "/SettingScreen";

  const SettingScreen({Key? key}) : super(key: key);
  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool ghostModeSwitch = false;
  bool showSexualitySwitch = false;
  bool instagramSwitch = false;
  bool whatsappSwitch = false;
  bool countriesLoaded = false;
  int selectedOriginCountryId = 0;
  int selectedSexualityId = 0;
  int selectedSexualityInterestId = 0;
  int showMePeopleFromCountryId = 0;
  int selectedOriginCountryIdFromServer = 0;
  int showMePeopleFromCountryIdFromServer = 0;
  int minimunAgeToMatch = 0;
  int maximunAgeToMatch = 0;
  List<String> finalCountries = [];
  var instagramTextFieldFocusNode = FocusNode();
  TextEditingController instaCtr = TextEditingController();
  TextEditingController whatsCtr = TextEditingController();
  var _userInfo;
  // ignore: prefer_typing_uninitialized_variables
  var countries;
  var sexOrientations;
  List<String> finalSexOrientations = [];
  List<String> finalPreferedSexOrientations = [];
  int mySexualOrientationIdFromServer = 0;

  bool sexLoaded = false;

  // Future<List<Country>> countries;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _controller.repeat();
    print("Paises" + finalCountries.toString());
    _userInfo = readConfig();
    getAvailableCountries();
    getAvailableSexualPreferences();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              "Aplicando cambios...",
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
        bottomNavigationBar: const MainMenu(),
        backgroundColor: const Color(0xff020202),
        appBar: AppBar(
            elevation: 0,
            backgroundColor: const Color(0xff020202),
            title: const Text('LoVers - Ajustes')),
        body: SingleChildScrollView(
          child: Column(
            children: [
              buildBody(),
              const SizedBox(
                height: 20,
              ),
              saveContactChanges(),
              const SizedBox(
                height: 20,
              ),
              buildFilters(),
              const SizedBox(
                height: 20,
              ),
              // buildSaveBtn(),
              saveChanges(),
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget saveChanges() {
    return GestureDetector(
      onTap: () async {
        context.loaderOverlay.show();
        try {
          final settings =
              Provider.of<SettingsProvider>(context, listen: false);
          final userProv = Provider.of<AuthProvider>(context, listen: false);
          User currentUser = await userProv.readLocalUserInfo();
          Country paisOrigen =
              await getCountryByName(finalCountries[selectedOriginCountryId]);
          SexualOrientation mySexuality;
          if (selectedSexualityId != 0) {
            mySexuality = await getSexualityByName(
                finalSexOrientations[selectedSexualityId]);
          } else {
            mySexuality = SexualOrientation(
                enabled: true, id: 0, name: "No Identificado");
          }
          // if (showMePeopleFromCountryId == 0) {
          //   showMePeopleFromCountryId++;
          //   allCountries = true;
          // }
          var pref = showMePeopleFromCountryId - 1;
          if (pref < 0) {
            currentUser.preferedCountryId = 0;
          } else {
            Country paisPref = await getCountryByName(finalCountries[pref]);
            currentUser.preferedCountryId = paisPref.id;
          }

          currentUser.countryId = paisOrigen.id;
          currentUser.sexualOrientationId = mySexuality.id;
          currentUser.minimunAgeToMatch = minimunAgeToMatch;
          currentUser.maximunAgeToMatch = maximunAgeToMatch;
          var filtersUpdated = await settings.setFiltersPreferences(
              currentUser.id!, currentUser);
          if (filtersUpdated) {
            finalCountries.clear();
            context.loaderOverlay.hide();
            CoolAlert.show(
                context: context,
                animType: CoolAlertAnimType.slideInDown,
                backgroundColor: Colors.white,
                loopAnimation: false,
                type: CoolAlertType.success,
                text: "Configuracion aplicada correctamente",
                title: "Exito!");
            setState(() {});
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
              text: e.toString(),
              title: "Error");
        } finally {
          context.loaderOverlay.hide();
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width * .8,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            // color: const Color(0xff242424),
            color: Colors.blue),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Text(
                "Aplicar Filtros",
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget saveContactChanges() {
    return GestureDetector(
      onTap: () async {
        try {
          context.loaderOverlay.show();
          final settings =
              Provider.of<SettingsProvider>(context, listen: false);
          final userProv = Provider.of<AuthProvider>(context, listen: false);
          User currentUser = await userProv.readLocalUserInfo();
          bool instagramResponse = false;
          bool whatsappResponse = false;
          if (instaCtr.text != "") {
            instagramResponse =
                await settings.setInstagram(currentUser.id!, instaCtr.text);
          } else {
            instagramResponse = true;
          }
          if (whatsCtr.text != "") {
            whatsappResponse =
                await settings.setWhatsapp(currentUser.id!, whatsCtr.text);
          } else {
            whatsappResponse = true;
          }
          currentUser.showMySexuality = showSexualitySwitch;
          bool showMySexualityResponse =
              await settings.showMySexuality(showSexualitySwitch);
          bool ghostModeResponse = ghostModeSwitch
              ? await settings.activateGhostMode(currentUser.id!)
              : await settings.deactivateGhostMode(currentUser.id!);
          bool manageInstagram = instagramSwitch
              ? await settings.activateInstagram(currentUser.id!)
              : await settings.deactivateInstagram(currentUser.id!);
          bool manageWhatsapp = whatsappSwitch
              ? await settings.activateWhatsapp(currentUser.id!)
              : await settings.deactivateWhatsapp(currentUser.id!);
          print(
              "$manageWhatsapp $manageInstagram $ghostModeResponse $whatsappResponse $instagramResponse");
          if (instagramResponse &&
              whatsappResponse &&
              ghostModeResponse &&
              manageInstagram &&
              showMySexualityResponse &&
              manageWhatsapp) {
            // finalCountries.clear();
            context.loaderOverlay.hide();
            CoolAlert.show(
                context: context,
                animType: CoolAlertAnimType.slideInDown,
                backgroundColor: Colors.white,
                loopAnimation: false,
                type: CoolAlertType.success,
                text: "Tu informacion ha sido guardada correctamente",
                title: "Yeah!");
            setState(() {});
          } else {
            // finalCountries.clear();
            context.loaderOverlay.hide();
            CoolAlert.show(
                context: context,
                animType: CoolAlertAnimType.slideInDown,
                backgroundColor: Colors.white,
                loopAnimation: false,
                type: CoolAlertType.error,
                text:
                    "Ha ocurrido un error al someter el cambio, verifique la informacion",
                title: "ERROR");
            setState(() {});
          }
          context.loaderOverlay.hide();
        } catch (e) {
          context.loaderOverlay.hide();
          CoolAlert.show(
              context: context,
              type: CoolAlertType.error,
              animType: CoolAlertAnimType.slideInDown,
              backgroundColor: Colors.white,
              loopAnimation: false,
              text: e.toString(),
              title: "Error");
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width * .8,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            // color: const Color(0xff242424),
            color: Colors.blue),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Text(
                "Guardar",
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFilters() {
    const List<String> local_paises = <String>[
      "United States",
      "Canada",
      "Afghanistan",
      "Albania",
      "Algeria",
      "American Samoa",
      "Andorra",
      "Angola",
      "Anguilla",
      "Antarctica",
      "Antigua and/or Barbuda",
      "Argentina",
      "Armenia",
      "Aruba",
      "Australia",
      "Austria",
      "Azerbaijan",
      "Bahamas",
      "Bahrain",
      "Bangladesh",
      "Barbados",
      "Belarus",
      "Belgium",
      "Belize",
      "Benin",
      "Bermuda",
      "Bhutan",
      "Bolivia",
      "Bosnia and Herzegovina",
      "Botswana",
      "Bouvet Island",
      "Brazil",
      "British Indian Ocean Territory",
      "Brunei Darussalam",
      "Bulgaria",
      "Burkina Faso",
      "Burundi",
      "Cambodia",
      "Cameroon",
      "Cape Verde",
      "Cayman Islands",
      "Central African Republic",
      "Chad",
      "Chile",
      "China",
      "Christmas Island",
      "Cocos (Keeling) Islands",
      "Colombia",
      "Comoros",
      "Congo",
      "Cook Islands",
      "Costa Rica",
      "Croatia (Hrvatska)",
      "Cuba",
      "Cyprus",
      "Czech Republic",
      "Denmark",
      "Djibouti",
      "Dominica",
      "Dominican Republic",
      "East Timor",
      "Ecudaor",
      "Egypt",
      "El Salvador",
      "Equatorial Guinea",
      "Eritrea",
      "Estonia",
      "Ethiopia",
      "Falkland Islands (Malvinas)",
      "Faroe Islands",
      "Fiji",
      "Finland",
      "France",
      "France, Metropolitan",
      "French Guiana",
      "French Polynesia",
      "French Southern Territories",
      "Gabon",
      "Gambia",
      "Georgia",
      "Germany",
      "Ghana",
      "Gibraltar",
      "Greece",
      "Greenland",
      "Grenada",
      "Guadeloupe",
      "Guam",
      "Guatemala",
      "Guinea",
      "Guinea-Bissau",
      "Guyana",
      "Haiti",
      "Heard and Mc Donald Islands",
      "Honduras",
      "Hong Kong",
      "Hungary",
      "Iceland",
      "India",
      "Indonesia",
      "Iran (Islamic Republic of)",
      "Iraq",
      "Ireland",
      "Israel",
      "Italy",
      "Ivory Coast",
      "Jamaica",
      "Japan",
      "Jordan",
      "Kazakhstan",
      "Kenya",
      "Kiribati",
      "Korea, Democratic People's Republic of",
      "Korea, Republic of",
      "Kosovo",
      "Kuwait",
      "Kyrgyzstan",
      "Lao People's Democratic Republic",
      "Latvia",
      "Lebanon",
      "Lesotho",
      "Liberia",
      "Libyan Arab Jamahiriya",
      "Liechtenstein",
      "Lithuania",
      "Luxembourg",
      "Macau",
      "Macedonia",
      "Madagascar",
      "Malawi",
      "Malaysia",
      "Maldives",
      "Mali",
      "Malta",
      "Marshall Islands",
      "Martinique",
      "Mauritania",
      "Mauritius",
      "Mayotte",
      "Mexico",
      "Micronesia, Federated States of",
      "Moldova, Republic of",
      "Monaco",
      "Mongolia",
      "Montserrat",
      "Morocco",
      "Mozambique",
      "Myanmar",
      "Namibia",
      "Nauru",
      "Nepal",
      "Netherlands",
      "Netherlands Antilles",
      "New Caledonia",
      "New Zealand",
      "Nicaragua",
      "Niger",
      "Nigeria",
      "Niue",
      "Norfork Island",
      "Northern Mariana Islands",
      "Norway",
      "Oman",
      "Pakistan",
      "Palau",
      "Panama",
      "Papua New Guinea",
      "Paraguay",
      "Peru",
      "Philippines",
      "Pitcairn",
      "Poland",
      "Portugal",
      "Puerto Rico",
      "Qatar",
      "Reunion",
      "Romania",
      "Russian Federation",
      "Rwanda",
      "Saint Kitts and Nevis",
      "Saint Lucia",
      "Saint Vincent and the Grenadines",
      "Samoa",
      "San Marino",
      "Sao Tome and Principe",
      "Saudi Arabia",
      "Senegal",
      "Seychelles",
      "Sierra Leone",
      "Singapore",
      "Slovakia",
      "Slovenia",
      "Solomon Islands",
      "Somalia",
      "South Africa",
      "South Georgia South Sandwich Islands",
      "South Sudan",
      "Spain",
      "Sri Lanka",
      "St. Helena",
      "St. Pierre and Miquelon",
      "Sudan",
      "Suriname",
      "Svalbarn and Jan Mayen Islands",
      "Swaziland",
      "Sweden",
      "Switzerland",
      "Syrian Arab Republic",
      "Taiwan",
      "Tajikistan",
      "Tanzania, United Republic of",
      "Thailand",
      "Togo",
      "Tokelau",
      "Tonga",
      "Trinidad and Tobago",
      "Tunisia",
      "Turkey",
      "Turkmenistan",
      "Turks and Caicos Islands",
      "Tuvalu",
      "Uganda",
      "Ukraine",
      "United Arab Emirates",
      "United Kingdom",
      "United States minor outlying islands",
      "Uruguay",
      "Uzbekistan",
      "Vanuatu",
      "Vatican City State",
      "Venezuela",
      "Vietnam",
      "Virigan Islands (British)",
      "Virgin Islands (U.S.)",
      "Wallis and Futuna Islands",
      "Western Sahara",
      "Yemen",
      "Yugoslavia",
      "Zaire",
      "Zambia",
      "Zimbabwe"
    ];
    return Container(
        width: MediaQuery.of(context).size.width * .8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          color: const Color(0xff242424),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20, top: 20),
                  child: Row(
                    children: const [
                      Text(
                        "Filtros",
                        style: TextStyle(
                          color: Color(0xff00b2ff),
                          fontSize: 23,
                        ),
                      ),
                      Icon(Icons.filter_list_alt, color: Color(0xff00b2ff))
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: const [
                Padding(
                  padding: EdgeInsets.only(left: 20, top: 25),
                  child: Text(
                    "Soy de",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                    ),
                  ),
                ),
              ],
            ),
            FutureBuilder<List<Country>>(
              future: countries,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(
                    color: Colors.pink,
                  );
                }
                if (snapshot.hasError) {
                  return const Text("Ups! error getting available countries");
                }
                if (snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done) {
                  List<Country>? paises = snapshot.data;

                  paises?.forEach((element) {
                    if (!finalCountries.contains(element.name)) {
                      finalCountries.add(element.name!);
                    }
                  });
                  if (finalCountries.isEmpty) {
                    finalCountries = local_paises;
                  }
                  String? countryName;
                  if (selectedOriginCountryIdFromServer != 0) {
                    countryName = paises
                        ?.where((element) =>
                            element.id == selectedOriginCountryIdFromServer)
                        .first
                        .name;
                  } else {
                    countryName = "Desconocido";
                  }
                  // int x = finalCountries.indexWhere((country) => country==countryName);
                  return Padding(
                    padding:
                        const EdgeInsets.only(left: 20, top: 10, right: 20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.location_on_rounded,
                              color: Colors.red,
                            ),
                            Text(
                              countryName!,
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        CustomPicker(
                          placeHolder: "Selecciona:",
                          options: finalCountries,
                          onChange: (int x) async {
                            if (kDebugMode) {
                              selectedOriginCountryId = x;

                              print("Selected ${finalCountries[x]}");
                            }
                          },
                        ),
                      ],
                    ),
                  );
                }
                return const Text("Error getting countries");
              },
            ),
            Row(
              children: const [
                Padding(
                  padding: EdgeInsets.only(left: 20, top: 10),
                  child: Text(
                    "Muestrame personas de",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                    ),
                  ),
                ),
              ],
            ),
            FutureBuilder<List<Country>>(
              future: countries,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(
                    color: Colors.pink,
                  );
                }
                if (snapshot.hasError) {
                  return const Text("Ups! error getting available countries");
                }
                if (snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done) {
                  List<Country>? paises = snapshot.data;
                  List<String> finalCountries = ["Todos los paises"];
                  paises?.forEach((element) {
                    finalCountries.add(element.name!);
                  });

                  String? countryName;
                  if (showMePeopleFromCountryIdFromServer == 0) {
                    countryName = "Todo el mundo";
                  } else {
                    countryName = paises
                        ?.where((element) =>
                            element.id == showMePeopleFromCountryIdFromServer)
                        .first
                        .name;
                  }

                  return Padding(
                    padding:
                        const EdgeInsets.only(left: 20, top: 10, right: 20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.location_on_rounded,
                              color: Colors.red,
                            ),
                            Text(
                              countryName!,
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        CustomPicker(
                          placeHolder: "Pais:",
                          onChange: (int x) {
                            showMePeopleFromCountryId = x;
                            print("Pais de preferencia ${finalCountries[x]}");
                          },
                          options: finalCountries,
                        ),
                      ],
                    ),
                  );
                }
                return const Text("Error getting countries");
              },
            ),
            Row(
              children: const [
                Padding(
                  padding: EdgeInsets.only(left: 20, top: 10),
                  child: Text(
                    "Muestrame rango de edad",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                    ),
                  ),
                ),
              ],
            ),
            Text(minimunAgeToMatch.toString()),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 10),
              child: CustomRangeSelect(
                onChange: (RangeValues valores) {
                  minimunAgeToMatch = valores.start.toInt();
                  maximunAgeToMatch = valores.end.toInt();
                  bool ageAdviced = false;
                  if (minimunAgeToMatch == 18 && !ageAdviced) {
                    CoolAlert.show(
                        context: context,
                        animType: CoolAlertAnimType.slideInDown,
                        backgroundColor: Colors.white,
                        loopAnimation: false,
                        type: CoolAlertType.info,
                        title: "Informacion 👮🏽‍♂️",
                        text:
                            "Ups! por politicas de la aplicacion nuestros usuarios deben ser mayores de edad, por tal razon no deberiamos permitir filtrado para menores de 18 🚓");
                    ageAdviced = true;
                  }
                  if (maximunAgeToMatch == 100) {
                    CoolAlert.show(
                        context: context,
                        animType: CoolAlertAnimType.slideInDown,
                        backgroundColor: Colors.white,
                        loopAnimation: false,
                        type: CoolAlertType.info,
                        title: "Informacion 🫣",
                        text:
                            "Hey! te gustan los extremos, no creemos que vayas a encontrar alguien que los alcance, pero por si las moscas. 👴🏼👵🏽");
                    ageAdviced = true;
                  }
                  if (kDebugMode) {
                    print("$minimunAgeToMatch - $maximunAgeToMatch");
                  }
                },
              ),
            ),
            Row(
              children: const [
                Padding(
                  padding: EdgeInsets.only(left: 20, top: 10),
                  child: Text(
                    "Me identifico como:",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                    ),
                  ),
                ),
              ],
            ),
            FutureBuilder<List<SexualOrientation>>(
              future: sexOrientations,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(
                    color: Colors.pink,
                  );
                }
                if (snapshot.hasError) {
                  return const Text("Ups! error getting sexual orientations");
                }
                if (snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done) {
                  List<SexualOrientation>? sexes = snapshot.data;
                  // List<String> finalSexs = ["No identificado"];
                  finalSexOrientations.add("No identificado");
                  sexes?.forEach((element) {
                    finalSexOrientations.add(element.name!);
                  });

                  String? sexName;

                  if (mySexualOrientationIdFromServer != 0) {
                    sexName = sexes
                        ?.where((element) =>
                            element.id == mySexualOrientationIdFromServer)
                        .first
                        .name;
                  } else {
                    sexName = "No establecido";
                  }
                  // if (showMePeopleFromCountryIdFromServer == 0) {
                  //   countryName = "Todo el mundo";
                  // } else {
                  //   countryName = paises
                  //       ?.where((element) =>
                  //           element.id == showMePeopleFromCountryIdFromServer)
                  //       .first
                  //       .name;
                  // }

                  return Padding(
                    padding:
                        const EdgeInsets.only(left: 20, top: 10, right: 20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.flag_rounded,
                              color: Colors.red,
                            ),
                            Text(
                              sexName!,
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        CustomPicker(
                          placeHolder: "Sexualidad:",
                          onChange: (int x) {
                            selectedSexualityId = x;
                            print("Sexualidad  ${finalSexOrientations[x]}");
                          },
                          options: finalSexOrientations,
                        ),
                      ],
                    ),
                  );
                }
                return const Text("Error getting sex's");
              },
            ),
          ],
        ));
  }

  Widget buildBody() {
    Size screenSize = MediaQuery.of(context).size;
    bool init = true;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: screenSize.width * .9,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            color: const Color(0xff1b1b1b),
          ),
          child: FutureBuilder<User>(
            future: _userInfo,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(color: Colors.pink);
              }
              if (snapshot.hasError) {
                return const Text("Error 34");
              }
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                // ghostModeSwitch = snapshot.data!.modoFantasma!;
                // instagramSwitch = snapshot.data!.instagramUserEnabled!;
                // whatsappSwitch = snapshot.data!.whatsappNumberEnabled!;
                String igUser = snapshot.data!.instagramUser!;
                String whatsappNumber = snapshot.data!.whatsappNumber!;

                return Column(
                  children: [
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 30, top: 30),
                          child: Text(
                            "Modo fantasma",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 15,
                              left: MediaQuery.of(context).size.width * .28),
                          child: Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.15,
                                child: CupertinoSwitch(
                                  value: ghostModeSwitch,
                                  onChanged: (value) {
                                    setState(() {
                                      ghostModeSwitch = value;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 30, top: 10),
                          child: Text(
                            "Mostrar mi sexualidad",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 10,
                              left: MediaQuery.of(context).size.width * .11),
                          child: Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.16,
                                child: CupertinoSwitch(
                                  value: showSexualitySwitch,
                                  onChanged: (value) {
                                    setState(() {
                                      showSexualitySwitch = value;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 30, top: 10),
                          child: Text(
                            "Instagram",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 10,
                              left: MediaQuery.of(context).size.width * .4),
                          child: CupertinoSwitch(
                            // activeColor: Colors.grey,
                            value: instagramSwitch,
                            onChanged: (value) async {
                              setState(() {
                                instagramSwitch = value;
                              });
                              // final configProvider =
                              //     Provider.of<SettingsProvider>(context,
                              //         listen: false);
                              // final authProvider = Provider.of<AuthProvider>(
                              //     context,
                              //     listen: false);
                              // User currentUser =
                              //     await authProvider.readLocalUserInfo();
                              // if (value) {
                              //   await configProvider
                              //       .activateInstagram(currentUser.id!);
                              //   setState(() {});
                              // } else {
                              //   await configProvider
                              //       .deactivateInstagram(currentUser.id!);
                              //   setState(() {});
                              // }
                              // setState(() {});
                            },
                          ),
                        ),
                      ],
                    ),
                    buildInstagramField(igUser),
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 30, top: 10),
                          child: Text(
                            "Whatsapp",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 10,
                              left: MediaQuery.of(context).size.width * .4),
                          child: CupertinoSwitch(
                            // activeColor: Colors.grey,
                            value: whatsappSwitch,
                            onChanged: (value) async {
                              setState(() {
                                whatsappSwitch = value;
                              });
                              // final configProvider =
                              //     Provider.of<SettingsProvider>(context,
                              //         listen: false);
                              // final authProvider = Provider.of<AuthProvider>(
                              //     context,
                              //     listen: false);
                              // User currentUser =
                              //     await authProvider.readLocalUserInfo();
                              // if (value) {
                              //   await configProvider
                              //       .activateWhatsapp(currentUser.id!);
                              //   setState(() {});
                              // } else {
                              //   await configProvider
                              //       .deactivateWhatsapp(currentUser.id!);
                              //   setState(() {});
                              // }
                              // setState(() {});
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: buildWhatsappField(whatsappNumber)),
                  ],
                );
              }
              return const Text("Error s04");
            },
          ),
        ),
      ],
    );
  }

  Future<void> getAvailableCountries() async {
    try {
      final countryProvider =
          Provider.of<CountriesProvider>(context, listen: false);
      final cou = countryProvider.getAllCountries();
      countries = cou;
      countriesLoaded = true;
    } catch (e) {
      countriesLoaded = false;
    }
    // cou.forEach((element) {
    //   countries.add(element.name!);
    // });
  }

  Future<User> readConfig() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    User currentUser = await authProvider.readLocalUserInfo();
    // setState(() {

    // });
    minimunAgeToMatch = currentUser.minimunAgeToMatch!;
    maximunAgeToMatch = currentUser.maximunAgeToMatch!;
    ghostModeSwitch = currentUser.modoFantasma!;
    instagramSwitch = currentUser.instagramUserEnabled!;
    showSexualitySwitch = currentUser.showMySexuality!;
    whatsappSwitch = currentUser.whatsappNumberEnabled!;
    selectedOriginCountryIdFromServer = currentUser.countryId!;
    showMePeopleFromCountryIdFromServer = currentUser.preferedCountryId!;
    mySexualOrientationIdFromServer = currentUser.sexualOrientationId!;
    return currentUser;
  }

  buildWhatsappField(String number) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding:
              const EdgeInsets.only(left: 20, top: 16, bottom: 16, right: 20),
          child: TextField(
            controller: whatsCtr,
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
              hintText: number.length >= 10 ? number : "Whatsapp",
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

  buildInstagramField(String user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding:
              const EdgeInsets.only(left: 20, top: 16, bottom: 16, right: 20),
          child: TextField(
            focusNode: instagramTextFieldFocusNode,
            controller: instaCtr,
            // autofocus: true,
            onChanged: (x) {
              // if (x.length >= 3 && !profileInfoChanged) {
              //   profileInfoChanged =true;
              //   setState(() {});

              // }
              // if (x.length == 0 && profileInfoChanged) {
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
              hintText: user.length >= 2 ? user : "Instagram",
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
        //           var igSetted = await settings.setInstagram(
        //               currentUser.id!, instaCtr.text);
        //           if (igSetted) {
        //             profileInfoChanged = false;
        //             setState(() {});
        //           }
        //         },
        //         icon: Icon(Icons.save_rounded, size: 18),
        //         label: Text("GUARDAR INSTAGRAM"),
        //       ),
        //     ))
      ],
    );
  }

  buildSaveBtn() {
    return ElevatedButton.icon(
      onPressed: () async {},
      icon: Icon(Icons.save_rounded, size: 18),
      label: Text("GUARDAR"),
    );
  }

  Future<Country> getCountryByName(String finalCountri) async {
    final settings = Provider.of<CountriesProvider>(context, listen: false);
    Country pais = await settings.getCountryByName(finalCountri);
    return pais;
  }

  getAvailableSexualPreferences() {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final cou = authProvider.getAllSexualOrientations();
      sexOrientations = cou;
      sexLoaded = true;
    } catch (e) {
      sexLoaded = false;
    }
  }

  getSexualityByName(String finalSexOrientation) async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    SexualOrientation sex =
        await auth.getSexualOrientationByName(finalSexOrientation);
    return sex;
  }
}
