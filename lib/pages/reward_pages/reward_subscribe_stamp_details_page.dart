import 'package:flutter/material.dart';
import 'package:flutter_voullet_consumer_app/pages/shared_pages/empty_page.dart';

import './../../apis/reward_apis.dart';
import './../../enums/generic_enums.dart';
import './../../helpers/custom_shared_preferences.dart';
import './../../widgets/custom_alert_dialog.dart';
import './../../widgets/custom_progress_dialog.dart';
import '../../helpers/static_functions.dart';
import '../shared_pages/loading_page.dart';
import '../../resources/theme_designs.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_sized_box.dart';
import './../../helpers/extension_functions.dart';

class RewardSubscribeStampDetailsPage extends StatefulWidget {
  final int stampID;

  RewardSubscribeStampDetailsPage({Key key, @required this.stampID}) : super(key: key);

  @override
  _RewardSubscribeStampDetailsPageState createState() => _RewardSubscribeStampDetailsPageState();
}

class _RewardSubscribeStampDetailsPageState extends State<RewardSubscribeStampDetailsPage> {
  final String _title = "Subscribe Card Details";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getStampDetails(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          return snapshot.data;
        } else {
          return Scaffold(
            appBar: CustomAppBar(
              title: _title,
            ),
            body: LoadingPage(),
          );
        }
      },
    );
  }

  Future<Widget> _getStampDetails() async {
    final int _userID = (await CustomSharedPreferences.getValue(StorageEnum.userID)).toInt();
    RewardStampDetailsRequest _rewardStampDetailsRequest = RewardStampDetailsRequest(widget.stampID, _userID);
    RewardStampDetailsResponse _rewardStampDetailsResponse = await RewardApis.rewardStampDetailsApi(_rewardStampDetailsRequest);

    return Scaffold(
      appBar: CustomAppBar(
        title: _title,
      ),
      body: _rewardStampDetailsResponse.error.isStringEmpty()
          ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Image.memory(
                      _rewardStampDetailsResponse.stampImageBytes,
                      width: double.infinity,
                      height: StaticFunctions.getDeviceHeight(context) / 3.5,
                      fit: BoxFit.fill,
                    ),
                  ),
                  CustomSizedBox(),
                  Card(
                    margin: ThemeDesign.containerPaddingLeftRight,
                    elevation: 5,
                    shape: ThemeDesign.cardBorderStyle,
                    child: Padding(
                      padding: EdgeInsets.all(ThemeDesign.containerPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    _rewardStampDetailsResponse.orgName,
                                    style: ThemeDesign.titleStyleWithColourRegular,
                                  ),
                                  CustomSizedBox(height: 10),
                                  Text(
                                    _rewardStampDetailsResponse.stampName,
                                    style: ThemeDesign.emptyStyle,
                                  ),
                                ],
                              ),
                              Spacer(),
                              RaisedButton(
                                child: Text(
                                  "Subscribe",
                                  style: TextStyle(
                                    fontSize: ThemeDesign.buttonFontSize,
                                  ),
                                ),
                                padding: EdgeInsets.all(10),
                                textColor: ThemeDesign.buttonTextPrimaryColor,
                                color: ThemeDesign.buttonPrimaryColor,
                                onPressed: () async {
                                  CustomProgressDialog.show(context);
                                  final _rewardStampSubscribeRequest = RewardStampSubscribeRequest(_rewardStampDetailsResponse.stampID, _userID);
                                  final _rewardStampSubscribeResponse = await RewardApis.rewardSubscribeApi(_rewardStampSubscribeRequest);
                                  CustomProgressDialog.hide(context);

                                  if (!_rewardStampSubscribeResponse.error.isStringEmpty()) {
                                    CustomAlertDialog.showError(context, _rewardStampSubscribeResponse.error);
                                  } else {
                                    await CustomAlertDialog.showSuccess(context, "Subscribed Successfully.");

                                    Navigator.of(context).pop();
                                  }
                                },
                              ),
                            ],
                          ),
                          CustomSizedBox(height: 40),
                          Text(
                            "Rewards",
                            style: ThemeDesign.titleStyleWithColourRegular,
                          ),
                          CustomSizedBox(height: 10),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: _rewardStampDetailsResponse?.stampTiers?.length ?? 0,
                            itemBuilder: (context, index) {
                              final _stampTier = _rewardStampDetailsResponse.stampTiers[index];

                              return GestureDetector(
                                child: Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                  child: Row(
                                    children: <Widget>[
                                      Image.memory(
                                        _stampTier.stampTierImageBytes,
                                        height: 40,
                                        width: 40,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        '${_stampTier.stampTierName}',
                                        style: ThemeDesign.emptyStyle,
                                        textAlign: TextAlign.justify,
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) => _buildStampTierDialog(context, _stampTier),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          : EmptyPage(text: _rewardStampDetailsResponse.error),
    );
  }

  Widget _buildStampTierDialog(BuildContext context, RewardStampTierItem stampTier) {
    return new AlertDialog(
      title: const Text('Reward Details'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Image.memory(
              stampTier.stampTierImageBytes,
              height: 100,
              fit: BoxFit.fitWidth,
            ),
          ),
          Text("${stampTier.stampTierName} - ${stampTier.stampQuantity} stamp(s)"),
          Text(stampTier.stampTierDescription),
        ],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Close'),
        ),
      ],
    );
  }
}
