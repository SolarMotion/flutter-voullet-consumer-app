import 'package:flutter/material.dart';

import './../../widgets/custom_app_bar.dart';

class RedeemByInputCodePage extends StatefulWidget {
  final String voucherDesignName;

  RedeemByInputCodePage({Key key, @required this.voucherDesignName}) : super(key: key);

  @override
  _RedeemByInputCodePageState createState() => _RedeemByInputCodePageState();
}

class _RedeemByInputCodePageState extends State<RedeemByInputCodePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.voucherDesignName,
        centerTitle: true,
      ),
      body: Center(
        child: Text('Not found in PPT. Need further confirmation.'),
      ),
    );
  }
}
