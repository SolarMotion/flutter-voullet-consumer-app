import 'package:flutter/material.dart';
import 'package:flutter_voullet_consumer_app/resources/theme_designs.dart';

class CustomCircularProgressIndicator extends StatelessWidget {
  final Alignment alignment;
  final double paddingTop;
  final double paddingBottom;

  CustomCircularProgressIndicator({this.alignment = Alignment.centerLeft, this.paddingTop = 0, this.paddingBottom = 0});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(
          top: paddingTop == 0 ? ThemeDesign.containerPadding : paddingTop,
          bottom: paddingBottom,
        ),
        alignment: alignment,
        child: CircularProgressIndicator());
  }
}
