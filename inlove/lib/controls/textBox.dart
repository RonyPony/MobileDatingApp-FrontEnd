import 'package:flutter/material.dart';

class CustomTextBox extends StatelessWidget {
  const CustomTextBox({Key? key,required this.text,required this.controller, required this.onChange}) : super(key: key);
 final String text;
 final Function onChange;
 final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            controller: controller,
            onChanged: onChange(),
            cursorColor: Colors.black,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              fillColor: Color(0xfc616161),
              filled: true,
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(20)),
              hintText: text,
            ),
          ),
        ),
      ],
    );
  }
}