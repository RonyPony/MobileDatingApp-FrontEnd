import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:inlove/models/country.dart';
import 'package:inlove/models/user.dart';
import 'package:inlove/providers/countriesProvider.dart';
import 'package:inlove/providers/settingsProvider.dart';
import 'package:provider/provider.dart';

import '../controls/mainbtn.dart';
import '../controls/menu.dart';
import '../controls/picker.dart';
import '../controls/rangeSelect.dart';
import '../controls/textBox.dart';
import '../providers/authProvider.dart';

class SettingScreen extends StatefulWidget {
  static String routeName = "/SettingScreen";
  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool ghostMode = false;
  bool instagram = false;
  bool whatsapp = false;
  bool countriesLoaded = false;

  var countries;
  // Future<List<Country>> countries;

  @override
  void initState() {
    readConfig();
    getAvailableCountries();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: MainMenu(),
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
            buildFilters(),
            const SizedBox(
              height: 20,
            ),
            deleteAccount(),
            const SizedBox(
              height: 20,
            ),
          ],
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

  Widget buildFilters() {
    const List<String> local_paisesFrom = <String>[
      "DE TODO EL MUNDO",
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
                  return Text("Ups! error getting available countries");
                }
                if (snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done) {
                  List<Country>? paises = snapshot.data;
                  List<String> finalCountries = [];
                  paises?.forEach((element) {
                    finalCountries.add(element.name!);
                  });
                  if (finalCountries.length == 0) {
                    finalCountries = local_paises;
                  }
                  return Padding(
                    padding:
                        const EdgeInsets.only(left: 20, top: 10, right: 20),
                    child: CustomPicker(
                      placeHolder: "Pais:",
                      options: finalCountries, onChange: (){
                        print("object");
                      },
                    ),
                  );
                }
                return Text("Error getting countries");
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
                  return Text("Ups! error getting available countries");
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
                      onChange: (){

                      },
                      options: finalCountries,
                    ),
                  );
                }
                return Text("Error getting countries");
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
            const Padding(
              padding: EdgeInsets.only(left: 20, top: 10),
              child: CustomRangeSelect(),
            )
          ],
        ));
  }

  Widget buildBody() {
    Size screenSize = MediaQuery.of(context).size;
    final configProvider =
        Provider.of<SettingsProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    TextEditingController instaCtr = TextEditingController();
    TextEditingController whatsCtr = TextEditingController();
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
                            style: const TextStyle(
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
                    Container(
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
                    Container(
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
                return Text("Error 34");
              }
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                bool ghostMode = snapshot.data!.modoFantasma!;
                bool instagram = snapshot.data!.instagramUserEnabled!;
                bool whatsapp = snapshot.data!.whatsappNumberEnabled!;
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

                              final configProvider =
                                  Provider.of<SettingsProvider>(context,
                                      listen: false);
                              final authProvider = Provider.of<AuthProvider>(
                                  context,
                                  listen: false);
                              User currentUser =
                                  await authProvider.readLocalUserInfo();
                              if (value) {
                                final activated = await configProvider
                                    .activateGhostMode(currentUser.id!);
                                setState(() {});
                              } else {
                                final deactivated = await configProvider
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
                            style: const TextStyle(
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
                                final activated = await configProvider
                                    .activateInstagram(currentUser.id!);
                                setState(() {});
                              } else {
                                final deactivated = await configProvider
                                    .deactivateInstagram(currentUser.id!);
                                setState(() {});
                              }
                              setState(() {});
                            },
                          ),
                        ),
                      ],
                    ),
                    Container(
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
                                final activated = await configProvider
                                    .activateWhatsapp(currentUser.id!);
                                setState(() {});
                              } else {
                                final deactivated = await configProvider
                                    .deactivateWhatsapp(currentUser.id!);
                                setState(() {});
                              }
                              setState(() {});
                            },
                          ),
                        ),
                      ],
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        child: CustomTextBox(
                          text: "Whatsapp",
                          onChange: () {},
                          controller: whatsCtr,
                        )),
                  ],
                );
              }
              return Text("Error s04");
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
}
