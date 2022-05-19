import 'package:flutter/material.dart';
import 'package:inlove/routes/export.dart';

class CustomButton extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
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
                  color: color1db9fc,
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
                    Text(
                      "Entrar",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28.fS,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 105,
            top: 0,
            child: Container(
              width: 66,
              height: 65,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: SvgPicture.asset(AppImages.flecha),
            ),
          ),
        ],
      ),
    );
  }
}
