import 'package:barcode_scan/barcode_scan.dart';
import 'package:barcode_scan/model/android_options.dart';
import 'package:barcode_scan/model/scan_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../helpers/static_functions.dart';
import '../../resources/theme_designs.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_sized_box.dart';
import '../shared_pages/loading_page.dart';
import './../../apis/reward_apis.dart';
import './../../enums/generic_enums.dart';
import './../../helpers/custom_shared_preferences.dart';
import './../../helpers/extension_functions.dart';
import './../../pages/shared_pages/empty_page.dart';
import './../../widgets/custom_alert_dialog.dart';
import './../../widgets/custom_progress_dialog.dart';

class RewardStampBalanceDetailsPage extends StatefulWidget {
  final int stampID;

  RewardStampBalanceDetailsPage({Key key, @required this.stampID}) : super(key: key);

  @override
  _RewardStampBalanceDetailsPageState createState() => _RewardStampBalanceDetailsPageState();
}

class _RewardStampBalanceDetailsPageState extends State<RewardStampBalanceDetailsPage> {
  final String _title = "Card Details";

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

    RewardStampBalanceDetailsRequest _rewardStampBalanceDetailsRequest = RewardStampBalanceDetailsRequest(widget.stampID, _userID);
    RewardStampBalanceDetailsResponse _rewardStampBalanceDetailsResponse = await RewardApis.rewardStampBalanceDetailsApi(_rewardStampBalanceDetailsRequest);

    return Scaffold(
      appBar: CustomAppBar(
        title: _title,
      ),
      body: _rewardStampBalanceDetailsResponse.error.isStringEmpty()
          ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Image.memory(
                      _rewardStampBalanceDetailsResponse.stampImageBytes,
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
                                    _rewardStampBalanceDetailsResponse.stampName,
                                    style: ThemeDesign.titleStyleWithColourRegular,
                                  ),
                                  CustomSizedBox(height: 10),
                                  Text(
                                    "Total Stamps: ${_rewardStampBalanceDetailsResponse.stampQty ?? 0}",
                                    style: ThemeDesign.emptyStyle,
                                  ),
                                ],
                              ),
                              Spacer(),
                              RaisedButton(
                                child: Text(
                                  "Scan",
                                  style: TextStyle(
                                    fontSize: ThemeDesign.buttonFontSize,
                                  ),
                                ),
                                padding: EdgeInsets.all(10),
                                textColor: ThemeDesign.buttonTextPrimaryColor,
                                color: ThemeDesign.buttonPrimaryColor,
                                onPressed: () async {
                                  var result = await _scanQrCode();

                                  if (result.type == ResultType.Error) {
                                    await CustomAlertDialog.showError(context, result.rawContent);
                                  } else if (result.rawContent.isStringEmpty()) {
                                    await CustomAlertDialog.showError(context, "Invalid code");
                                  } else {
                                    CustomProgressDialog.show(context);
                                    final _rewardScanCodeRequest = RewardScanCodeRequest(result.rawContent, _userID);
                                    final _rewardScanCodeResponse = await RewardApis.rewardScanCodeApi(_rewardScanCodeRequest);
                                    CustomProgressDialog.hide(context);

                                    if (!_rewardScanCodeResponse.error.isStringEmpty()) {
                                      CustomAlertDialog.showError(context, _rewardScanCodeResponse.error);
                                    } else {
                                      await CustomAlertDialog.showSuccess(context, _rewardScanCodeResponse.scanMessage);

                                      final _refreshedRewardStampBalanceDetailsResponse = await RewardApis.rewardStampBalanceDetailsApi(_rewardStampBalanceDetailsRequest);
                                      setState(() {
                                        _rewardStampBalanceDetailsResponse = _refreshedRewardStampBalanceDetailsResponse;
                                      });
                                    }
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
                            itemCount: _rewardStampBalanceDetailsResponse?.rewardStampBalanceItems?.length ?? 0,
                            itemBuilder: (context, index) {
                              final _stampTier = _rewardStampBalanceDetailsResponse.rewardStampBalanceItems[index];
                              final _isEnoughStamp = _rewardStampBalanceDetailsResponse.stampQty >= _stampTier.tierQty;
                              final _message = _isEnoughStamp ? "${_stampTier.tierQty} stamp(s)" : "${(_stampTier.tierQty - _rewardStampBalanceDetailsResponse.stampQty).abs()} more to go";

                              return GestureDetector(
                                child: Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Image.memory(
                                            _stampTier.stampImageBytes,
                                            height: 40,
                                            width: 40,
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            '${_stampTier.tierName}',
                                            style: ThemeDesign.descriptionStyle,
                                            textAlign: TextAlign.justify,
                                          ),
                                        ],
                                      ),
                                      Text(
                                        _message,
                                        style: ThemeDesign.emptyStyle,
                                        textAlign: TextAlign.justify,
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) => _buildStampTierDialog(context, _stampTier, _isEnoughStamp),
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
          : EmptyPage(text: _rewardStampBalanceDetailsResponse.error),
    );
  }

  Widget _buildStampTierDialog(BuildContext context, RewardStampBalanceTierItem stampTier, bool isEnoughStamp) {
    return new AlertDialog(
      title: const Text('Reward Details'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Image.memory(
              stampTier.stampImageBytes,
              height: 100,
              fit: BoxFit.fitWidth,
            ),
          ),
          Text("${stampTier.tierName} - ${stampTier.tierQty} stamp(s)"),
          Text(stampTier.tierDescription),
          isEnoughStamp
              ? Center(
                  child: Image.network(
                    "http://charitydemoweb.azurewebsites.net/QREncoderApp.ashx?c=${stampTier.redeemCode}",
                    fit: BoxFit.fill,
                    loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes : null,
                        ),
                      );
                    },
                  ),
                )
              : Container(),
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

  Future<ScanResult> _scanQrCode() async {
    try {
      var options = ScanOptions(
        strings: {
          "cancel": "Cancel",
          "flash_on": "Flash On",
          "flash_off": "Flash Off",
        },
        restrictFormat: BarcodeFormat.values,
        useCamera: -1,
        autoEnableFlash: false,
        android: AndroidOptions(
          aspectTolerance: 0,
          useAutoFocus: true,
        ),
      );

      var result = await BarcodeScanner.scan(options: options);

      return result;
    } on PlatformException catch (e) {
      var result = ScanResult(
        type: ResultType.Error,
        format: BarcodeFormat.unknown,
      );

      if (e.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          result.rawContent = 'The user did not grant the camera permission!';
        });
      } else {
        result.rawContent = 'Unknown error: $e';
      }

      return result;
    }
  }
}
