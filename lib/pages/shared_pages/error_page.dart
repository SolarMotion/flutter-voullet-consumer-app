import 'package:flutter/material.dart';

import './../../resources/theme_designs.dart';

class ErrorPage extends StatelessWidget {
  final String text;

  ErrorPage({Key key, this.text = "Error. Please contact support."}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: ThemeDesign.emptyStyle,
      ),
    );
  }
}
