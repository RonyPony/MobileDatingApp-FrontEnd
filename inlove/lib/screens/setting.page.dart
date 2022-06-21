// ignore_for_file: constant_identifier_names

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:inlove/models/country.dart';
import 'package:inlove/models/user.dart';
import 'package:inlove/providers/countries_provider.dart';
import 'package:inlove/providers/settings_provider.dart';
import 'package:provider/provider.dart';

import '../controls/main_btn.dart';
import '../controls/menu.dart';
import '../controls/picker.dart';
import '../controls/rangeSelect.dart';
import '../controls/text_box.dart';
import '../providers/auth_provider.dart';

class SettingScreen extends StatefulWidget {
  static String routeName = "/SettingScreen";

  const SettingScreen({Key? key}) : super(key: key);
  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool ghostMode = false;
  bool instagram = false;
  bool whatsapp = false;
  bool countriesLoaded = false;
  int selectedOriginCountryId = 0;
  int showMePeopleFromCountryId = 0;
  int minimunAgeToMatch = 0;
  int maximunAgeToMatch = 0;
  List<String> finalCountries = [];
  TextEditingController instaCtr = TextEditingController();
  TextEditingController whatsCtr = TextEditingController();

  // ignore: prefer_typing_uninitialized_variables
  var countries;

  bool whatsappChanged = false;

  bool instagramChanged = false;
  // Future<List<Country>> countries;

  @override
  void initState() {
    readConfig();
    getAvailableCountries();
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
    );
  }

  Widget saveChanges() {
    return GestureDetector(
      onTap: () async {
        try {
          final settings =
              Provider.of<SettingsProvider>(context, listen: false);
          final userProv = Provider.of<AuthProvider>(context, listen: false);
          User currentUser = await userProv.readLocalUserInfo();
          Country paisOrigen =
              await getCountryByName(finalCountries[selectedOriginCountryId]);
          if (showMePeopleFromCountryId == 0) {
            showMePeopleFromCountryId++;
          }
          var pref = showMePeopleFromCountryId - 1;

          Country paisPref = await getCountryByName(finalCountries[pref]);
          currentUser.countryId = paisOrigen.id;
          currentUser.preferedCountryId = paisPref.id;
          currentUser.minimunAgeToMatch = minimunAgeToMatch;
          currentUser.maximunAgeToMatch = maximunAgeToMatch;
          var filtersUpdated = await settings.setFiltersPreferences(
              currentUser.id!, currentUser);
          if (filtersUpdated) {
            finalCountries.clear();
            CoolAlert.show(
                context: context,
                type: CoolAlertType.success,
                text: "Configuracion aplicada correctamente",
                title: "Exito");
            setState(() {});
          }
        } catch (e) {
          CoolAlert.show(
              context: context,
              type: CoolAlertType.error,
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
          final settings =
              Provider.of<SettingsProvider>(context, listen: false);
          final userProv = Provider.of<AuthProvider>(context, listen: false);
          User currentUser = await userProv.readLocalUserInfo();
          Country paisOrigen =
              await getCountryByName(finalCountries[selectedOriginCountryId]);
          if (showMePeopleFromCountryId == 0) {
            showMePeopleFromCountryId++;
          }
          var pref = showMePeopleFromCountryId - 1;

          Country paisPref = await getCountryByName(finalCountries[pref]);
          currentUser.countryId = paisOrigen.id;
          currentUser.preferedCountryId = paisPref.id;
          currentUser.minimunAgeToMatch = minimunAgeToMatch;
          currentUser.maximunAgeToMatch = maximunAgeToMatch;
          var filtersUpdated = await settings.setFiltersPreferences(
              currentUser.id!, currentUser);
          if (filtersUpdated) {
            finalCountries.clear();
            CoolAlert.show(
                context: context,
                type: CoolAlertType.success,
                text: "Configuracion aplicada correctamente",
                title: "Exito");
            setState(() {});
          }
        } catch (e) {
          CoolAlert.show(
              context: context,
              type: CoolAlertType.error,
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
              children: const [
                Padding(
                  padding: EdgeInsets.only(left: 20, top: 20),
                  child: Text(
                    "Filtros",
                    style: TextStyle(
                      color: Color(0xff00b2ff),
                      fontSize: 23,
                    ),
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
                    finalCountries.add(element.name!);
                  });
                  if (finalCountries.isEmpty) {
                    finalCountries = local_paises;
                  }
                  return Padding(
                    padding:
                        const EdgeInsets.only(left: 20, top: 10, right: 20),
                    child: CustomPicker(
                      placeHolder: "Pais:",
                      options: finalCountries,
                      onChange: (int x) async {
                        if (kDebugMode) {
                          selectedOriginCountryId = x;

                          print("Selected ${finalCountries[x]}");
                        }
                      },
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

                  return Padding(
                    padding:
                        const EdgeInsets.only(left: 20, top: 10, right: 20),
                    child: CustomPicker(
                      placeHolder: "Pais:",
                      onChange: (int x) {
                        showMePeopleFromCountryId = x;
                        print("Pais de preferencia ${finalCountries[x]}");
                      },
                      options: finalCountries,
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
            Padding(
              padding: EdgeInsets.only(left: 20, top: 10),
              child: CustomRangeSelect(
                onChange: (RangeValues valores) {
                  minimunAgeToMatch = valores.start.toInt();
                  maximunAgeToMatch = valores.end.toInt();
                  if (kDebugMode) {
                    print("$minimunAgeToMatch - $maximunAgeToMatch");
                  }
                },
              ),
            )
          ],
        ));
  }

  Widget buildBody() {
    Size screenSize = MediaQuery.of(context).size;

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
            future: readConfig(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
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
                              top: 10,
                              left: MediaQuery.of(context).size.width * .25),
                          child: CupertinoSwitch(
                            activeColor: Colors.grey,
                            value: ghostMode,
                            onChanged: (value) async {
                              ghostMode = value;
                              setState(() {});
                            },
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
                            activeColor: Colors.grey,
                            value: instagram,
                            onChanged: (value) {
                              instagram = value;
                              setState(() {});
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: CustomTextBox(
                          text: "Instagram",
                          onChange: () {},
                          controller: instaCtr,
                        )),
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
                            activeColor: Colors.grey,
                            value: whatsapp,
                            onChanged: (value) {
                              whatsapp = value;
                              setState(() {});
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: CustomTextBox(
                          text: "Whatsapp",
                          onChange: () {},
                          controller: whatsCtr,
                        )),
                  ],
                );
              }
              if (snapshot.hasError) {
                return const Text("Error 34");
              }
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                bool ghostMode = snapshot.data!.modoFantasma!;
                bool instagram = snapshot.data!.instagramUserEnabled!;
                bool whatsapp = snapshot.data!.whatsappNumberEnabled!;
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
                              left: MediaQuery.of(context).size.width * .3),
                          child: CupertinoSwitch(
                            activeColor: Colors.grey,
                            value: ghostMode,
                            onChanged: (value) async {
                              ghostMode = value;

                              final configProvider =
                                  Provider.of<SettingsProvider>(context,
                                      listen: false);
                              final authProvider = Provider.of<AuthProvider>(
                                  context,
                                  listen: false);
                              User currentUser =
                                  await authProvider.readLocalUserInfo();
                              if (value) {
                                setState(() {});
                                await configProvider
                                    .activateGhostMode(currentUser.id!);
                              } else {
                                await configProvider
                                    .deactivateGhostMode(currentUser.id!);
                                setState(() {});
                              }
                              setState(() {});
                            },
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
                            activeColor: Colors.grey,
                            value: instagram,
                            onChanged: (value) async {
                              instagram = value;
                              final configProvider =
                                  Provider.of<SettingsProvider>(context,
                                      listen: false);
                              final authProvider = Provider.of<AuthProvider>(
                                  context,
                                  listen: false);
                              User currentUser =
                                  await authProvider.readLocalUserInfo();
                              if (value) {
                                await configProvider
                                    .activateInstagram(currentUser.id!);
                                setState(() {});
                              } else {
                                await configProvider
                                    .deactivateInstagram(currentUser.id!);
                                setState(() {});
                              }
                              setState(() {});
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
                            activeColor: Colors.grey,
                            value: whatsapp,
                            onChanged: (value) async {
                              whatsapp = value;
                              final configProvider =
                                  Provider.of<SettingsProvider>(context,
                                      listen: false);
                              final authProvider = Provider.of<AuthProvider>(
                                  context,
                                  listen: false);
                              User currentUser =
                                  await authProvider.readLocalUserInfo();
                              if (value) {
                                await configProvider
                                    .activateWhatsapp(currentUser.id!);
                                setState(() {});
                              } else {
                                await configProvider
                                    .deactivateWhatsapp(currentUser.id!);
                                setState(() {});
                              }
                              setState(() {});
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
              if (x.length >= 10) {
                whatsappChanged = true;
                setState(() {});
              }
              if (x.length == 0) {
                whatsappChanged = false;
                setState(() {});
              }
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
        Padding(
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * .3, bottom: 10),
            child: Visibility(
              visible: whatsappChanged,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final settings =
                      Provider.of<SettingsProvider>(context, listen: false);
                  final userProv =
                      Provider.of<AuthProvider>(context, listen: false);
                  User currentUser = await userProv.readLocalUserInfo();
                  var igSetted = await settings.setWhatsapp(
                      currentUser.id!, whatsCtr.text);
                  if (igSetted) {
                    whatsappChanged = false;
                    setState(() {});
                  }
                },
                icon: Icon(Icons.save_rounded, size: 18),
                label: Text("GUARDAR WHATSAPP"),
              ),
            ))
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
            controller: instaCtr,
            // autofocus: true,
            onChanged: (x) {
              // if (x.length >= 3) {
              //   instagramChanged = true;
              //   setState(() {});
              // }
              // if (x.length == 0) {
              //   instagramChanged = false;
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
        Padding(
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * .3, bottom: 10),
            child: Visibility(
              visible: instagramChanged,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final settings =
                      Provider.of<SettingsProvider>(context, listen: false);
                  final userProv =
                      Provider.of<AuthProvider>(context, listen: false);
                  User currentUser = await userProv.readLocalUserInfo();
                  var igSetted = await settings.setInstagram(
                      currentUser.id!, instaCtr.text);
                  if (igSetted) {
                    instagramChanged = false;
                    setState(() {});
                  }
                },
                icon: Icon(Icons.save_rounded, size: 18),
                label: Text("GUARDAR INSTAGRAM"),
              ),
            ))
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
}
