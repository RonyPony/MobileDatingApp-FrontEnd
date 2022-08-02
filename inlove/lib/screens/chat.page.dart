import 'dart:convert';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart' as fba;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:inlove/controls/menu.dart';
import 'package:inlove/helpers/emojies.dart';
import 'package:inlove/models/chat_arguments.dart';
import 'package:inlove/models/userMatch.dart';
import 'package:inlove/providers/auth_provider.dart';
import 'package:inlove/providers/match_provider.dart';
import 'package:inlove/screens/chat_spike.dart';
import 'package:inlove/screens/conversation.page.dart';
import 'package:inlove/screens/home.page.dart';
import 'package:inlove/screens/userProfile.page.dart';
import 'package:provider/provider.dart';

import '../models/photo.dart';
import '../models/user.dart';
import '../providers/chat_provider.dart';
import '../providers/photo_provider.dart';

class ChatScreen extends StatefulWidget {
  static String routeName = '/chatScreen';

  @override
  State<ChatScreen> createState() => _StateChatScreen();
}

class _StateChatScreen extends State<ChatScreen> {
  List<User>? _matchinUsers;
  late User _currentUser;
  List<ChatArguments> _chatList = [];
  var listMessages;

  @override
  void initState() {
    // TODO: implement initState
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
          title: const Text('LoVers - Mensajes'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildMatches(),
              // _aChat("Ronel Cruz C.", "Hola que tal, todo bien?"),
              // _aChat("Juana Almanzar", "Hola que tal, todo bien?"),
              // _aChat("Michelle Jimenez", "Hola que tal, todo bien?"),
              _buildRoms(),
              // _buildEmptyChats(),
            ],
          ),
        ));
  }

  Future<Image> getUserImage(User? data) async {
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
        fit: BoxFit.fill,
        height: MediaQuery.of(context).size.height * .5,
        width: MediaQuery.of(context).size.width * .9,
      );
    }
  }

  Future<Widget> _aMatch(bool active, User usuario) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    User _currentUser = await authProvider.readLocalUserInfo();
    Future<Image> userimage = getUserImage(usuario);
    var instance = fba.FirebaseAuth.instance;
    String _uid = instance.currentUser!.uid;

    String currentUserId = _currentUser.id.toString();
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    String secondUID = "";
    String secondID = usuario.id.toString();
    Stream<QuerySnapshot<Map<String, dynamic>>> response =
        chatProvider.getUIDfromEmail(usuario.email!);
    response.listen((event) {
      if (event.docs.length >= 1) {
        secondUID = event.docs.first["userId"];
      } else {
        print("Wating for event");
      }
    });
    return FutureBuilder<Image>(
      future: userimage,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          Emojies ee = Emojies();
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                ee.getAnEmmoji(true),
                style: TextStyle(fontSize: 48),
              ),
            ],
          );
        }
        if (snapshot.hasError) {
          return Text("err 334");
        }
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          return Padding(
            padding: const EdgeInsets.only(right: 10, left: 10),
            child: Stack(children: [
              GestureDetector(
                onTap: () async {
                  print("Waiting 1 sec");
                  await Future.delayed(Duration(seconds: 1), () {});
                  print("Creating room");

                  String roomId = chatProvider.createRoom(
                      _uid,
                      currentUserId,
                      secondUID,
                      secondID,
                      usuario.name! + " " + usuario.lastName!);
                  ChatArguments args = ChatArguments(usuario, roomId);
                  Navigator.pushNamed(context, Conversation.routeName,
                      arguments: args);
                  // Navigator.pushNamed(context, UserProfileScreen.routeName,
                  //     arguments: usuario.id);
                },
                child: Container(
                  width: 150,
                  height: 120,
                  child: snapshot.data,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      color: Color(0xff3c3c3c),
                      border: Border.all(
                          width: 3,
                          color: active ? Colors.pinkAccent : Colors.grey)),
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 70, left: 3),
                    child: Container(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(.5),
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(10),
                              // topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              // bottomLeft: Radius.circular(10)
                            )),
                        child: Text(
                          usuario.name!,
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                ],
              )
            ]),
          );
        }
        return Text("Error");
      },
    );
  }

  _aChat(String userName, String messagePreview) {
    return Padding(
      padding: const EdgeInsets.only(left: 50, top: 20),
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width - 100,
            height: 75,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Color(0xff3c3c3c),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 10),
                  child: Column(
                    children: [
                      Container(
                        width: 55,
                        height: 53.29,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xff838383),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10, left: 10),
                      child: Text(
                        userName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontFamily: "Jaldi",
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5, left: 10),
                      child: Text(
                        messagePreview,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildMatches() {
    var matches = getMatches();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width - 50,
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            color: Color(0xff242424),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Padding(
                    padding: EdgeInsets.only(top: 25, left: 30),
                    child: SizedBox(
                      width: 214,
                      height: 44,
                      child: Text(
                        "Matches",
                        style: TextStyle(
                          color: Color(0xff00b2ff),
                          fontSize: 23,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              FutureBuilder<List<UserMatch>>(
                future: matches,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(color: Colors.pink);
                  }
                  if (snapshot.hasError) {
                    return Text("Error");
                  }
                  if (snapshot.hasData &&
                      snapshot.connectionState == ConnectionState.done) {
                    List<int?> usuariosId = [];

                    final authProvider =
                        Provider.of<AuthProvider>(context, listen: false);
                    usuariosId = snapshot.data!.map((e) {
                      if (e.originUserId == _currentUser.id) {
                        return e.finalUserId;
                      } else {
                        return e.originUserId;
                      }
                    }).toList();
                    // snapshot.data!.forEach((element) async {
                    //   var user =
                    //       await authProvider.findUserById(element.id!);
                    //   usuarios.add(user);
                    // });
                    if (usuariosId.length >= 1) {
                      return Container(
                        height: 100,
                        width: 300,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          // Let the ListView know how many items it needs to build.
                          itemCount: usuariosId.length,
                          // Provide a builder function. This is where the magic happens.
                          // Convert each item into a widget based on the type of item it is.
                          itemBuilder: (context, index) {
                            final item = usuariosId[index];
                            Future<User> usr = authProvider.findUserById(item!);
                            return FutureBuilder<User>(
                              future: usr,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  Emojies ee = Emojies();
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        ee.getAnEmmoji(true),
                                        style: TextStyle(fontSize: 48),
                                      ),
                                    ],
                                  );
                                }
                                if (snapshot.hasError) {
                                  return Text("err");
                                }
                                if (snapshot.hasData &&
                                    snapshot.connectionState ==
                                        ConnectionState.done) {
                                  return FutureBuilder<Widget>(
                                    future: _aMatch(true, snapshot.data!),
                                    builder: (context, snapshot2) {
                                      if (snapshot2.connectionState ==
                                          ConnectionState.waiting) {
                                        return CircularProgressIndicator();
                                      }
                                      if (snapshot2.hasError) {
                                        return Text("Error occurred");
                                      }
                                      if (snapshot2.hasData &&
                                          snapshot2.connectionState ==
                                              ConnectionState.done) {
                                        return snapshot2.data!;
                                      }
                                      return Text("No Data found");
                                    },
                                  );
                                }
                                return Text("Error 55");
                              },
                            );
                          },
                        ),
                      );
                    } else {
                      return _buildNoMatches();
                    }
                  }
                  return Text("XXX");
                },
              )
            ],
          ),
        ),
      ],
    );
  }

  Future<List<UserMatch>> getMatches() async {
    final provider = Provider.of<MatchProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    User currentUser = await authProvider.readLocalUserInfo();
    List<UserMatch> matches = await provider.getUserMatches(currentUser.id!);
    _currentUser = currentUser;
    try {
      // matches.forEach((element) async {
      //   if (element.originUserId != currentUser.id) {
      //     var user = await authProvider.findUserById(element.originUserId!);
      //     matchingUsers.add(user);
      //   } else {
      //     matchingUsers
      //         .add(await authProvider.findUserById(element.finalUserId!));
      //   }
      // });
      // print(matchingUsers);
      return matches;
      // matchingUsers = _future!;
      // _matchinUsers = matchingUsers;
    } catch (e) {
      print(e);
      return matches;
    }
  }

  _buildNoMatches() {
    return Column(
      children: [
        Icon(
          Icons.local_fire_department_outlined,
          color: Colors.orange.withOpacity(.4),
          size: 60,
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "Hey, aun no tienes matches",
          style: TextStyle(color: Colors.white.withOpacity(.4)),
        ),
        SizedBox(
          height: 10,
        ),
        ElevatedButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, HomePage.routeName, (route) => false);
            },
            child: Text("Consigue matches"))
      ],
    );
  }

  _buildEmptyChats() {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * .2),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.chat,
                size: 45,
                color: Colors.white.withOpacity(.2),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Oh-Oh!",
                style: TextStyle(
                    color: Colors.white.withOpacity(.2), fontSize: 25),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Estas lento con los chats",
                style: TextStyle(
                    color: Colors.white.withOpacity(.2), fontSize: 18),
              ),
              // ElevatedButton(
              //     onPressed: () {
              //       Navigator.pushNamed(context, ChatTest.routeName);
              //     },
              //     child: Text("GoToSpike"))
            ],
          )
        ],
      ),
    );
  }

  _buildRoms() {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    var auth = fba.FirebaseAuth.instance;
    String _uid = auth.currentUser!.uid;
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Container(
          height: MediaQuery.of(context).size.height - 100,
          width: MediaQuery.of(context).size.width - 50,
          child: Flexible(
              child: StreamBuilder<QuerySnapshot>(
                  stream: chatProvider.getChatRooms(_uid, 10),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      listMessages = snapshot.data!.docs;
                      if (listMessages.isNotEmpty) {
                        var auth = fba.FirebaseAuth.instance;
                        String _uid = auth.currentUser!.uid;
                        return ListView(
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                            Map<String, dynamic> data =
                                document.data()! as Map<String, dynamic>;
                            if (data['user1_uid'] == _uid ||
                                data['user2_uid'] == _uid) {
                              //sent
                              String secondUID = data['user1_uid'] == _uid
                                  ? data['user2_id']
                                  : data['user1_id'];
                              return _chatStrip(document, secondUID);
                            } else {
                              //receibed
                              return Text("NO",
                                  style: TextStyle(color: Colors.pinkAccent));
                            }
                          }).toList(),
                        );
                      } else {
                        return Center(child: _buildEmptyChats());
                      }
                    } else {
                      return CircularProgressIndicator(
                        color: Colors.yellow,
                      );
                    }
                  })),
        ),
        // _messageReceibed("Hola.", "11:45 PM"),
        // _messageReceibed("Como estas?", "11:46 PM"),
        // _messageSent("Hola.", "11:45 PM"),
      ],
    );
  }

  Widget _chatStrip(DocumentSnapshot<Object?> room, String userId) {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    Stream<QuerySnapshot<Map<String, dynamic>>> response =
        chatProvider.getEmailFromFirebase(userId);
    var _secondUserEmail;
    response.listen((event) {
      if (event.docs.length >= 1) {
        _secondUserEmail = event.docs.first["userId"];
      }
    });
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    // Future<User> usr = authProvider.findUserByEmail(_secondUserEmail);
    // String jsoned = jsonDecode(room.data().toString());
    Future<QuerySnapshot<Map<String, dynamic>>> _snap =
        FirebaseFirestore.instance
            .collection(FirestoreConstants.chatCollectionName)
            .doc(room.id)
            .collection(FirestoreConstants.messagesCollectionName)
            // .limit(1)
            .get();
    //       .then((value){
    // print("Fetched ==>>>" + value.docs.first.get("content"));
    //       });
    return GestureDetector(
      onTap: () async {
        User _finalUser = await authProvider.findUserById(int.parse(userId));
        ChatArguments args = ChatArguments(_finalUser, room.id);
        Navigator.pushNamed(context, Conversation.routeName, arguments: args);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
              color: Color(0xff242424), borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.only(left: 20, top: 20, bottom: 20),
            child: Row(
              children: [
                Column(
                  children: [
                    CircleAvatar(
                      child: Text("IL"),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Text(
                            room.get("displayName"),
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          future: _snap,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            }
                            if (snapshot.hasError) {
                              return Text("Error found");
                            }
                            if (snapshot.hasData &&
                                snapshot.connectionState == ConnectionState.done) {
                              
                              if (snapshot.data!.docs.length>=1) {
                                String cont =
                                    snapshot.data!.docs.last.get("content");
                                return Text(
                                  cont,
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(.5)),
                                );
                              }else{
                                return Text("No hay mensajes",style: TextStyle(
                                      color: Colors.white.withOpacity(.5)));
                              }
                            }
                            return Text("No Data");
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
