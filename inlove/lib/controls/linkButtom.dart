import 'package:flutter/material.dart';

class CustomLinkButton extends StatefulWidget {
  final String tittle;
  const CustomLinkButton({
    Key? key,
    required this.tittle,
  }) : super(key: key);
  @override
  State<CustomLinkButton> createState() => _CustomLinkButtonState();
}

class _CustomLinkButtonState extends State<CustomLinkButton> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.tittle,
      style: const TextStyle(
          color: Colors.white,
          decoration: TextDecoration.underline,
          fontSize: 25),
    );
  }
}
