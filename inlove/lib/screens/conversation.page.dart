import 'package:flag/flag.dart';
import 'package:flutter/material.dart';

import '../controls/menu.dart';

class Conversation extends StatefulWidget {
  static String routeName = '/conversation';
  @override
  State<Conversation> createState() => _buildState();
}

class _buildState extends State<Conversation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar:  _buildMessageBox(),
        backgroundColor: const Color(0xff020202),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xff020202),
          title: const Text(''),
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildName(),
                    _buildSocialInfo(),
                  ],
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
                  width: 348,
                  height: 542,
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
        ));
  }

  _buildPhoto() {
    return Padding(
      padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 1 / 9,
          right: MediaQuery.of(context).size.width * .05),
      child: Container(
        width: 67,
        height: 67,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xff838383),
        ),
      ),
    );
  }

  _buildName() {
    return Padding(
      padding: const EdgeInsets.only(),
      child: Text(
        "Ronel Cruz",
        style: TextStyle(
          color: Colors.white,
          fontSize: 33,
          fontFamily: "Jaldi",
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  _buildSocialInfo() {
    return Text(
      "@wipo | 809-9905832",
      style: TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
    );
  }

  _buildFlag() {
    return Padding(
      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * .1),
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
      padding: EdgeInsets.only(top: 20, right: 120),
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
      padding: EdgeInsets.only(top: 20, left: 150),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 10,left: 10,right: 10),
      child: Container(
      width: 374,
      height: 61,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Container(
                  width: 265,
                  height: 36,
                  child: TextField(),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(
                      color: Color(0xff3c3c3c),
                      width: 1,
                    ),
                  ),
                ),
          )
        ],
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          color: Color(0xff1b1b1b),
      )),
    );
  }
}
