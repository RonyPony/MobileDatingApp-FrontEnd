import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

const double _kItemExtent = 32.0;

class CustomPicker extends StatefulWidget {
  const CustomPicker(
      {Key? key, required this.placeHolder, required this.options})
      : super(key: key);
  final String placeHolder;
  final List<String> options;
  @override
  State<CustomPicker> createState() => _CustomPickerState();
}

class _CustomPickerState extends State<CustomPicker> {
  int _selectedFruit = 0;

  // This shows a CupertinoModalPopup with a reasonable fixed height which hosts CupertinoPicker.
  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
              height: 216,
              padding: const EdgeInsets.only(top: 6.0),
              // The Bottom margin is provided to align the popup above the system navigation bar.
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              // Provide a background color for the popup.
              color: CupertinoColors.systemBackground.resolveFrom(context),
              // Use a SafeArea widget to avoid system overlaps.
              child: SafeArea(
                top: false,
                child: child,
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.grey,
      child: DefaultTextStyle(
        style: TextStyle(
          color: CupertinoColors.label.resolveFrom(context),
          fontSize: 22.0,
        ),
        child: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(widget.placeHolder + " "),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  // Display a CupertinoPicker with list of fruits.
                  onPressed: () => _showDialog(
                    CupertinoPicker(
                      magnification: 1.22,
                      squeeze: 1.2,
                      useMagnifier: true,
                      itemExtent: _kItemExtent,
                      // This is called when selected item is changed.
                      onSelectedItemChanged: (int selectedItem) {
                        setState(() {
                          _selectedFruit = selectedItem;
                        });
                      },
                      children: List<Widget>.generate(widget.options.length,
                          (int index) {
                        return Center(
                          child: Text(
                            widget.options[index],
                          ),
                        );
                      }),
                    ),
                  ),
                  // This displays the selected fruit name.
                  child: Text(
                    widget.options[_selectedFruit],
                    style: const TextStyle(
                      fontSize: 22.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
