import 'package:flutter/material.dart';

import 'package:flutter_voullet_consumer_app/helpers/static_functions.dart';
import 'package:flutter_voullet_consumer_app/resources/theme_designs.dart';
import 'package:flutter_voullet_consumer_app/widgets/custom_sized_box.dart';
import './../../widgets/custom_app_bar.dart';

class DownloadIndexPage extends StatefulWidget {
  @override
  _DownloadIndexPageState createState() => _DownloadIndexPageState();
}

class _DownloadIndexPageState extends State<DownloadIndexPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Column(
        children: <Widget>[
          MerchantImage(),
          CustomSizedBox(),
          MerchantInputRow(),
        ],
      ),
    );
  }
}

class MerchantImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset("assets/pictures/quill_banner.png");
  }
}

class MerchantInputRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ThemeDesign.containerPaddingLeftRight,
      child: Column(
        children: <Widget>[
          Padding(
            padding: ThemeDesign.containerPaddingTopBottom,
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Download Coupon",
                style: ThemeDesign.titleStyleWithColourRegular,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              InkWell(
                child: Column(
                  children: <Widget>[
                    Image.asset(
                      "assets/pictures/input_code.png",
                      width: StaticFunctions.getDeviceWidth(context) / 2.2,
                      fit: BoxFit.fitWidth,
                    ),
                    CustomSizedBox(height: 10),
                    Text(
                      "Input Code",
                      style: ThemeDesign.emptyStyle,
                    ),
                  ],
                ),
                onTap: () {},
              ),
              Spacer(),
              InkWell(
                child: Column(
                  children: <Widget>[
                    Image.asset(
                      "assets/pictures/scan_qr_code.png",
                      width: StaticFunctions.getDeviceWidth(context) / 2.2,
                      fit: BoxFit.contain,
                    ),
                    CustomSizedBox(height: 10),
                    Text(
                      "Scan QR Code",
                      style: ThemeDesign.emptyStyle,
                    ),
                  ],
                ),
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
