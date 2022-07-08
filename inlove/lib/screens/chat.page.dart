import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:inlove/controls/menu.dart';
import 'package:inlove/screens/conversation.page.dart';

class ChatScreen extends StatefulWidget {
  static String routeName = '/chatScreen';
  @override
  State<ChatScreen> createState() => _StateChatScreen();
}

class _StateChatScreen extends State<ChatScreen> {
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
               _aChat("Ronel Cruz C.","Hola que tal, todo bien?"),
              _aChat("Juana Almanzar", "Hola que tal, todo bien?"),
              _aChat("Michelle Jimenez", "Hola que tal, todo bien?"),
               ],
          ),
        ));
  }

  _aMatch(bool active) {
    return Padding(
      padding: const EdgeInsets.only(right: 10, left: 10),
      child: Container(
        width: 200,
        height: 155,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            color: Color(0xff3c3c3c),
            border: Border.all(
                width: 3, color: active ? Colors.pinkAccent : Colors.grey)),
      ),
    );
  }

  _aChat(String userName,String messagePreview) {
    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(context, Conversation.routeName);
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 50, top: 20),
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width-100,
              height: 75,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Color(0xff3c3c3c),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10,top:10),
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
                        padding: EdgeInsets.only(top: 10,left: 10),
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
                        padding: EdgeInsets.only(top:5,left: 10),
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
      ),
    );
  }

  _buildMatches() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width - 50,
          height: 248.96,
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
                      height: 43.44,
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
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _aMatch(true),
                    _aMatch(false),
                    _aMatch(false),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
