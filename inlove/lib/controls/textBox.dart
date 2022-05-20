import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomTextBox extends StatefulWidget {
  final String text;
  CustomTextBox(this.text);
  @override
  State<StatefulWidget> createState() => _CustomTextBoxState();
}

class _CustomTextBoxState extends State<CustomTextBox> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            cursorColor: Colors.black,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              fillColor: Color(0xfc616161),
              filled: true,
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(20)),
              hintText: widget.text,
            ),
          ),
        ),
      ],
    );
  }
}
