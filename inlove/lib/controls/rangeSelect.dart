// ignore_for_file: file_names

import 'package:flutter/material.dart';

class CustomRangeSelect extends StatefulWidget {
  const CustomRangeSelect({Key? key, required this.onChange}) : super(key: key);
  final Function onChange;
  @override
  State<CustomRangeSelect> createState() => _CustomRangeSelectState();
}

class _CustomRangeSelectState extends State<CustomRangeSelect> {
  RangeValues _currentRangeValues = const RangeValues(40, 80);

  @override
  Widget build(BuildContext context) {
    return RangeSlider(
      values: _currentRangeValues,
      max: 100,
      divisions: 100,
      activeColor: Colors.pink,
      min: 18,
      labels: RangeLabels(
        _currentRangeValues.start.round().toString(),
        _currentRangeValues.end.round().toString(),
      ),
      onChanged: (RangeValues values) {
        setState(() {
          _currentRangeValues = values;
        });
        widget.onChange(values);
      },
    );
  }
}
