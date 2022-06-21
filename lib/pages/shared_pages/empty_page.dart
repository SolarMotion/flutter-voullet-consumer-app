import 'package:flutter/material.dart';

import './../../resources/theme_designs.dart';

class EmptyPage extends StatelessWidget {
  final String text;

  EmptyPage({Key key, this.text = "No item available"}) : super(key: key);

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
