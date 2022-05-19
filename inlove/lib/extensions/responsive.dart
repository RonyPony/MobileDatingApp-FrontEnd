import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
export 'package:sizer/sizer.dart';

extension ResponsiveCalculation on num {
  ///
  ///Returns the percent [Height] based on the design height reference
  ///
  double get dH => (this / 844) * 100.h;

  ///
  ///Returns the percent [Width] based on the design width reference
  ///
  double get dW => (this / 390) * 100.w;

  ///
  ///Returns the percent [Font Size] based on the design width reference
  ///
  double get fS => dW;
}

extension NavegarPage on BuildContext {
  void pushPage(Widget child) {
    Navigator.of(this).push(MaterialPageRoute(builder: (_) => child));
  }

  void pushNamedPage(
    String routeName, {
    Object? arguments,
  }) {
    Navigator.of(this).pushNamed(routeName);
  }
}
