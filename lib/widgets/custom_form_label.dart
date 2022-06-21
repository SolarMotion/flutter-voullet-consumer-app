import 'package:flutter/material.dart';

import './../resources/theme_designs.dart';

class CustomFormLabel extends StatelessWidget {
  final String text;
  final bool showAsterisk;

  CustomFormLabel(
    this.text, {
    Key key,
    this.showAsterisk = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Text.rich(
        TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: text,
              style: ThemeDesign.descriptionStyle,
            ),
            TextSpan(
              text: " ${showAsterisk ? "*" : ""}",
              style: ThemeDesign.asteriskStyle,
            ),
          ],
        ),
      ),
    );
  }
}