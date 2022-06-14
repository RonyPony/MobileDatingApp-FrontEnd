import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../providers/authProvider.dart';

class CustomBtn extends StatelessWidget {
  const CustomBtn({Key? key,required this.onPress}) : super(key: key);

  final Function onPress;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 181,
      height: 65,
      child: Stack(
        children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.topLeft,
              child: Container(
                width: 181,
                height: 53,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  color: Color(0xff1db9fc),
                ),
                padding: const EdgeInsets.only(
                  left: 37,
                  right: 69,
                  top: 11,
                  bottom: 9,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: (() => onPress),
                      child: const Text(
                        "Entrar",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 110,
            top: 0,
            child: Container(
                width: 70,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SvgPicture.asset('assets/flecha.svg')),
          ),
        ],
      ),
    );
  }
}