import 'package:flutter/material.dart';

class CustomSizedBox extends StatelessWidget {
  final double height;

  CustomSizedBox({Key key, this.height = 20}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: this.height,
    );
  }
}