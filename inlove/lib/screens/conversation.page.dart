import 'package:cool_alert/cool_alert.dart';
import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:inlove/screens/setting.page.dart';

import '../controls/menu.dart';

class Conversation extends StatefulWidget {
  static String routeName = '/conversation';
  @override
  State<Conversation> createState() => _buildState();
}

class _buildState extends State<Conversation> {
  bool hasText = false;
  TextEditingController messageToSend = TextEditingController();
  double _inputHeight = 50;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // messageToSend.addListener(_checkInputHeight);
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _heigth = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xff020202),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xff020202),
        title:  Row(
          children: [
            Text(''),
          ],
        ),
        toolbarHeight: 30,
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  _buildPhoto(),
                ],
              ),
              SizedBox(width: _width*.1,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildName(),
                  _buildSocialInfo(),
                ],
              ),
              SizedBox(
                width: _width * .1,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildFlag(),
                ],
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: SingleChildScrollView(
              child: Container(
                width: _width*.95,
                height: _heigth*.72,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(26),
                  color: Color(0xff1b1b1b),
                ),
                child: Column(
                  children: [
                    _messageReceibed("Hola.", "11:45 PM"),
                    _messageReceibed("Como estas?", "11:46 PM"),
                    _messageSent("Hola.", "11:45 PM"),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: _buildMessageBox(),
    );
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

  _buildName() {
    return const Text(
      "Ronel Cruz",
      style: TextStyle(
        color: Colors.white,
        fontSize: 33,
        fontFamily: "Jaldi",
        fontWeight: FontWeight.w700,
      ),
    );
  }

  _buildSocialInfo() {
    return const Text(
      "@wipo | 809-9905832",
      style: TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
    );
  }

  _buildFlag() {
    return GestureDetector(
      onTap: (){
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
            text:
                'este usuario ha seleccionado su pais como PAIS');
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

  _messageReceibed(String s, String t) {
    double _baseWidth = MediaQuery.of(context).size.width;
    double _baseHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only(top: 20, right: _baseWidth*.5),
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

  _messageSent(String s, String t) {
    double _baseWidth = MediaQuery.of(context).size.width;
    double _baseHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only(top: 20, left: _baseWidth*.5),
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
                  width: _width-100,
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      
                      controller: messageToSend,
                      // keyboardType: TextInputType.,
                      cursorColor: Colors.pink,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintStyle:
                            TextStyle(color: Colors.pink.withOpacity(.5)),
                        hintText: 'Escribe un mensaje...',
                      ),
                      style: const TextStyle(color: Colors.white,fontSize: 18),
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
                  ? SvgPicture.asset(
                      'assets/send.svg',
                      color: Colors.pink,
                      height: 40,
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
}
