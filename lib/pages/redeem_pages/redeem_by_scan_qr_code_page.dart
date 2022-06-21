import 'package:flutter/material.dart';

import './../../widgets/custom_app_bar.dart';

class RedeemByScanQrCodePage extends StatefulWidget {
  final String voucherDesignName;

  RedeemByScanQrCodePage({Key key, @required this.voucherDesignName}) : super(key: key);

  @override
  _RedeemByScanQrCodePageState createState() => _RedeemByScanQrCodePageState();
}

class _RedeemByScanQrCodePageState extends State<RedeemByScanQrCodePage> {
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
