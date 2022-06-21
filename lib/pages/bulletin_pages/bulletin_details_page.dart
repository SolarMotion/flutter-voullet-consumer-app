import 'package:flutter/material.dart';

import './../../enums/generic_enums.dart';
import './../../helpers/custom_shared_preferences.dart';
import './../../pages/shared_pages/loading_page.dart';
import './../../resources/theme_designs.dart';
import './../../apis/bulletin_apis.dart';
import './../../widgets/custom_app_bar.dart';
import './../../helpers/extension_functions.dart';

class BulletinDetailsPage extends StatefulWidget {
  final BulletinImageSlideItem bulletinDetails;
  final double slideWidth;
  final double slideHeight;

  BulletinDetailsPage({Key key, @required this.bulletinDetails, @required this.slideWidth, @required this.slideHeight})
      : super(key: key);

  @override
  _BulletinDetailsPageState createState() => _BulletinDetailsPageState();
}

class _BulletinDetailsPageState extends State<BulletinDetailsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getBulletinDetails(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          return snapshot.data;
        } else {
          return Scaffold(
            appBar: CustomAppBar(),
            body: LoadingPage(),
          );
        }
      },
    );
  }

  Future<Widget> _getBulletinDetails() async {
    var _userID = (await CustomSharedPreferences.getValue(StorageEnum.userID)).toInt();
    var _bulletinDetailsRequest = BulletinDetailsRequest(widget.bulletinDetails.bulletinID, _userID);
    BulletinDetailsResponse _bulletinDetailsResponse = await BulletinApis.bulletinDetailsApi(_bulletinDetailsRequest);

    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Image.memory(
              widget.bulletinDetails.imageBytes,
              width: widget.slideWidth,
              height: widget.slideHeight,
              fit: BoxFit.fill,
            ),
            Padding(
              padding: ThemeDesign.containerPaddingTopLeftRight,
              child: Text(
                _bulletinDetailsResponse.subject,
                style: TextStyle(
                  fontSize: ThemeDesign.titleFontSize,
                ),
              ),
            ),
            Padding(
              padding: ThemeDesign.containerPaddingTopLeftRight,
              child: Text(
                _bulletinDetailsResponse.body,
                style: TextStyle(
                  fontSize: ThemeDesign.descriptionFontSize,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.justify,
              ),
            )
          ],
        ),
      ),
    );
  }
}
