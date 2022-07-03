import 'package:flutter/material.dart';

class CustomRangeSelect extends StatefulWidget {
  const CustomRangeSelect({Key? key, required Null Function(RangeValues valores) onChange}) : super(key: key);

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
      activeColor: Colors.grey,
      min: 18,
      labels: RangeLabels(
        _currentRangeValues.start.round().toString(),
        _currentRangeValues.end.round().toString(),
      ),
      onChanged: (RangeValues values) {
        setState(() {
          _currentRangeValues = values;
        });
      },
    );
  }
}
