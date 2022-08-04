import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:inlove/models/chat_arguments.dart';
import 'package:inlove/providers/countries_provider.dart';
import 'package:inlove/screens/chat_spike.dart';
import 'package:inlove/screens/profile.page.dart';
import 'package:inlove/screens/setting.page.dart';
import 'package:inlove/screens/userProfile.page.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../controls/menu.dart';
import '../models/country.dart';
import '../models/user.dart';
import '../providers/chat_provider.dart';

class Conversation extends StatefulWidget {
  static String routeName = '/conversation';
  @override
  State<Conversation> createState() => _buildState();
}

class _buildState extends State<Conversation> {
  bool hasText = false;
  TextEditingController messageToSend = TextEditingController();
  double _inputHeight = 50;

  User _secondUser = User();
  Country _secondUserCountry = Country();
  String _roomId = "";

  var listMessages;

  var secondUserFirebaseId;

  @override
  void initState() {
    super.initState();
    // Future.delayed(Duration.zero, () {
    //   setState(() {
    // _secondUser = ModalRoute.of(context)!.settings.arguments as User;
    //   });
    // }).then((value) async {
    //   _secondUserCountry= await getUserCountry(_secondUser);
    // });
  }

  @override
  Widget build(BuildContext context) {
    ChatArguments args =
        ModalRoute.of(context)!.settings.arguments as ChatArguments;
    _secondUser = args.usuario;
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    Stream<QuerySnapshot<Map<String, dynamic>>> response =
        chatProvider.getUIDfromEmail(_secondUser.email!);
    response.listen((event) {
      secondUserFirebaseId = event.docs.first["userId"];
    });
    _roomId = args.roomId;
    Future.delayed(Duration.zero, () async {
      _secondUserCountry = await getUserCountry(_secondUser);
    });
    var auth = fbAuth.FirebaseAuth.instance;
    chatProvider.marRoomAndMessageAsSeen(_roomId, auth.currentUser!.uid);
    double _width = MediaQuery.of(context).size.width;
    double _heigth = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xff020202),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xff020202),
        title: Row(
          children: [
            Text(''),
          ],
        ),
        toolbarHeight: 30,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    _buildPhoto(),
                  ],
                ),
                SizedBox(
                  width: _width * .01,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildName(_secondUser),
                    _buildSocialInfo(_secondUser),
                  ],
                ),
                SizedBox(
                  width: _width * .1,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildFlag(_secondUser),
                  ],
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  Container(
                    // color: Colors.blue,
                    height: MediaQuery.of(context).size.height - 250,
                    width: MediaQuery.of(context).size.width - 60,
                    child: StreamBuilder<QuerySnapshot>(
                        stream: chatProvider.getChatMessage(_roomId, 10),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasData) {
                            listMessages = snapshot.data!.docs;
                            if (listMessages.isNotEmpty) {
                              var auth = fbAuth.FirebaseAuth.instance;
                              String _uid = auth.currentUser!.uid;
                              return Container(
                                child: ListView(
                                  children: snapshot.data!.docs
                                      .map((DocumentSnapshot document) {
                                    Map<String, dynamic> data = document.data()!
                                        as Map<String, dynamic>;
                                    if (data['idFrom'] == _uid) {
                                      //sent
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.grey),
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20, top: 10),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text(data['content'],
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 16,
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 10,
                                                          bottom: 10),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        data['seen']?"Visto":"Recibido",
                                                        style: TextStyle(
                                                            color: Colors
                                                                .grey[700]),
                                                      ),
                                                      Text(" | "),
                                                      Text(
                                                        readTimestamp(
                                                            data['timestamp']),
                                                        style: TextStyle(
                                                            color: Colors
                                                                .grey[700]),
                                                      ),
                                                      
                                                    ],
                                                  ),
                                                )
                                              ],
                                            )),
                                      );
                                    } else {
                                      //receibed
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.pinkAccent),
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20, top: 10),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text(data['content'],
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 16,
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 10,
                                                          bottom: 10),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        readTimestamp(
                                                            data['timestamp']),
                                                        style: TextStyle(
                                                            color: Colors
                                                                .grey[700]),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            )),
                                      );
                                    }
                                  }).toList(),
                                ),
                              );
                            } else {
                              return Center(child: _buildEmptyMessages());
                            }
                          } else {
                            return Center(
                                child: Text(
                              "Sincronizando Mensajes...",
                              style: TextStyle(color: Colors.white),
                            ));
                          }
                        }),
                  ),
                  // _messageReceibed("Hola.", "11:45 PM"),
                  // _messageReceibed("Como estas?", "11:46 PM"),
                  // _messageSent("Hola.", "11:45 PM"),
                ],
              ),
            ),
            _buildMessageBox()
          ],
        ),
      ),
      // bottomNavigationBar: _buildMessageBox(),
    );
  }

  String readTimestamp(String timestamp) {
    var now = new DateTime.now();
    var format = new DateFormat('hh:mm a');
    var date =
        new DateTime.fromMicrosecondsSinceEpoch(int.parse(timestamp) * 1000);
    var diff = date.difference(now);
    var time = '';

    if (diff.inSeconds <= 0 ||
        diff.inSeconds > 0 && diff.inMinutes == 0 ||
        diff.inMinutes > 0 && diff.inHours == 0 ||
        diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else {
      if (diff.inDays == 1) {
        time = diff.inDays.toString() + 'DAY AGO';
      } else {
        time = diff.inDays.toString() + 'DAYS AGO';
      }
    }

    return time;
  }

  _buildPhoto() {
    return Container(
      width: 67,
      height: 67,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xff838383),
      ),
    );
  }

  _buildName(User usuario) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, UserProfileScreen.routeName,
            arguments: usuario.id);
      },
      child: Text(
        usuario.name! + " " + usuario.lastName!.characters.take(1).string + ".",
        style: TextStyle(
          color: Colors.white,
          fontSize: 33,
          fontFamily: "Jaldi",
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  _buildSocialInfo(User usr) {
    return Text(
      "${usr.instagramUser!} | ${usr.whatsappNumber!}",
      style: TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
    );
  }

  Widget _buildFlag(User usr) {
    return GestureDetector(
      onTap: () {
        CoolAlert.show(
            context: context,
            type: CoolAlertType.info,
            backgroundColor: Colors.white,
            loopAnimation: false,
            cancelBtnText: "Configurar mi pais",
            showCancelBtn: true,
            onCancelBtnTap: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, SettingScreen.routeName, (route) => false);
            },
            title: "Pais",
            text: 'este usuario ha seleccionado su pais como PAIS');
      },
      child: Flag.fromString(
        "DO",
        fit: BoxFit.fill,
        height: 50,
        width: 50,
        borderRadius: 100,
      ),
    );
  }

  Widget _messageReceibed(String s, String t) {
    double _baseWidth = MediaQuery.of(context).size.width;
    double _baseHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only(top: 20, right: _baseWidth * .5),
      child: Container(
          width: _baseWidth * .4,
          height: 65,
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Color(0xfff15b6c),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20, left: 10),
                        child: Text(
                          s,
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      )
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          t,
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ),
                    ],
                  )
                ],
              ))),
    );
  }

  Widget _messageSent(String s, String t) {
    double _baseWidth = MediaQuery.of(context).size.width;
    double _baseHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only(top: 20, left: _baseWidth * .5),
      child: Container(
          width: _baseWidth * .4,
          height: 65,
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Color(0xff3c3c3c),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20, left: 10),
                        child: Text(
                          s,
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      )
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          t,
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ),
                    ],
                  )
                ],
              ))),
    );
  }

  _buildMessageBox() {
    double _width = MediaQuery.of(context).size.width;
    double _heigth = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
      child: Container(
          height: 70,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Container(
                  width: _width - 100,
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: messageToSend,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (value) {
                        _sendCurrentMessage();
                      },
                      cursorColor: Colors.pink,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintStyle:
                            TextStyle(color: Colors.pink.withOpacity(.5)),
                        hintText: 'Escribe un mensaje...',
                      ),
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                      onChanged: (t) {
                        setState(() {
                          if (t != "") {
                            hasText = true;
                          } else {
                            hasText = false;
                          }
                        });
                      },
                    ),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(
                      color: Color(0xff3c3c3c),
                      width: 1,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 13,
              ),
              hasText
                  ? GestureDetector(
                      onTap: () async {
                        _sendCurrentMessage();
                      },
                      child: SvgPicture.asset(
                        'assets/send.svg',
                        color: Colors.pink,
                        height: 40,
                      ),
                    )
                  : SvgPicture.asset(
                      'assets/send.svg',
                      color: Colors.grey,
                      height: 40,
                    )
            ],
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            color: Color(0xff1b1b1b),
          )),
    );
  }

  void _checkInputHeight() async {
    int count = messageToSend.text.split('\n').length;

    if (count == 0 && _inputHeight == 50.0) {
      return;
    }
    if (count <= 5) {
      // use a maximum height of 6 rows
      // height values can be adapted based on the font size
      var newHeight = count == 0 ? 50.0 : 28.0 + (count * 18.0);
      setState(() {
        _inputHeight = newHeight;
      });
    }
  }

  Future<Country> getUserCountry(User secondUser) async {
    final countryProvider =
        Provider.of<CountriesProvider>(context, listen: false);
    Country country =
        await countryProvider.findCountryById(secondUser.countryId.toString());
    return country;
  }

  Future<void> _sendCurrentMessage() async {
    String cntn = messageToSend.text;
    setState(() {
      messageToSend.clear();
    });
    print("Waiting...");
    await Future.delayed(Duration(milliseconds: 500), () {});
    print("Time is up!");
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    String messageContent = cntn;
    int type = MessageType().text;
    final auth = fbAuth.FirebaseAuth.instance;
    String CurrUID = auth.currentUser!.uid;
    if (secondUserFirebaseId != null) {
      chatProvider.sendChatMessage(
          messageContent, type, _roomId, CurrUID, secondUserFirebaseId);
    } else {
      CoolAlert.show(
          context: context,
          type: CoolAlertType.warning,
          text: "No pudimos enviar tu mensaje, intentalo mas tarde");
    }
  }

  Widget _buildEmptyMessages() {
    return Center(
      child: Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 3.5),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.mark_chat_unread_rounded,
                  color: Colors.white.withOpacity(.3),
                  size: 65,
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Toma la iniciativa!",
                    style: TextStyle(
                        color: Colors.white.withOpacity(.3), fontSize: 25)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Adelante, escribe algo",
                    style: TextStyle(color: Colors.white.withOpacity(.3))),
              ],
            )
          ],
        ),
      ),
    );
  }
}
