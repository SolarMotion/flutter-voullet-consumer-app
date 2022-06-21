import 'package:flutter/material.dart';

import './../resources/theme_designs.dart';

InputDecoration customTextFieldDecoration(String hintText) {
  final _textBoxBorderWidth = 2.0;
  final _textBoxBorderColor = Colors.grey;

  return InputDecoration(
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: _textBoxBorderColor,
        width: _textBoxBorderWidth,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: _textBoxBorderColor,
        width: _textBoxBorderWidth,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: _textBoxBorderColor,
        width: _textBoxBorderWidth,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: _textBoxBorderColor,
        width: _textBoxBorderWidth,
      ),
    ),
    hintText: hintText,
    errorStyle: ThemeDesign.errorStyle,
  );
}
