import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';

import './../../pages/redeem_pages/redeem_by_input_code_page.dart';
import './../../pages/redeem_pages/redeem_by_scan_qr_code_page.dart';
import './../../apis/cart_apis.dart';
import './../../apis/voucher_apis.dart';
import './../../enums/generic_enums.dart';
import './../../helpers/static_functions.dart';
import './../../pages/shared_pages/loading_page.dart';
import './../../resources/theme_designs.dart';
import './../../widgets/custom_alert_dialog.dart';
import './../../widgets/custom_sized_box.dart';
import './../../widgets/custom_app_bar.dart';
import './../../helpers/custom_shared_preferences.dart';
import './../../resources/app_settings.dart';
import './../../widgets/custom_progress_dialog.dart';
import './../../helpers/extension_functions.dart';

class VoucherDetailsPage extends StatefulWidget {
  final int voucherID;
  final int voucherDesignID;
  final ButtonTypeEnum redeemType;
  final VoucherTypeEnum voucherType;

  VoucherDetailsPage(
      {Key key,
      @required this.voucherDesignID,
      @required this.redeemType,
      @required this.voucherType,
      this.voucherID = 0})
      : super(key: key);

  @override
  _VoucherDetailsPageState createState() => _VoucherDetailsPageState();
}

class _VoucherDetailsPageState extends State<VoucherDetailsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getVoucherDesignDetails(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
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

  Future<Widget> _getVoucherDesignDetails() async {
    VoucherDetailsRequest _voucherDetailsRequest =
        VoucherDetailsRequest(widget.voucherDesignID, widget.voucherID);
    VoucherDetailsResponse _voucherDetailsResponse =
        await VoucherApis.voucherDetailsApi(_voucherDetailsRequest);

    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Image.memory(
                _voucherDetailsResponse.voucherDesignImageBytes,
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
                              "${_voucherDetailsResponse.voucherDesignName}",
                              style: ThemeDesign.titleStyleWithColourRegular,
                            ),
                            CustomSizedBox(height: 10),
                            Text(
                              "VALID UNTIL ${_voucherDetailsResponse.voucherDesignValidUntilDate}",
                              style: ThemeDesign.emptyStyle,
                            ),
                          ],
                        ),
                        Spacer(),
                        InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          child: Container(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Image.asset('assets/icons/icon_share.png',
                                  width: 40, height: 40),
                            ),
                          ),
                          onTap: () {
                            Share.text(
                                "Hello",
                                "${_voucherDetailsResponse.voucherDesignUrl}",
                                'text/plain');
                          },
                        ),
                      ],
                    ),
                    CustomSizedBox(height: 40),
                    Text(
                      "Terms & Cnditions",
                      style: ThemeDesign.titleStyleWithColourRegular,
                    ),
                    CustomSizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount:
                          _voucherDetailsResponse.voucherDesignTnCs.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Text(
                            '${_voucherDetailsResponse.voucherDesignTnCs[index]}',
                            style: ThemeDesign.emptyStyle,
                            textAlign: TextAlign.justify,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            CustomSizedBox(),
            Padding(
              padding: ThemeDesign.containerPaddingLeftRight,
              child: Text(
                "${widget.redeemType == ButtonTypeEnum.download ? "GET BY" : "REDEEM BY"}",
                style: ThemeDesign.titleStyleWithColourRegular,
              ),
            ),
            CustomSizedBox(height: 10),
            widget.redeemType == ButtonTypeEnum.download
                ? _constructDownloadWidgets()
                : _constructRedeemWidgets(_voucherDetailsResponse),
            CustomSizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _constructRedeemWidgets(
      VoucherDetailsResponse voucherDetailsResponse) {
    return Padding(
      padding: ThemeDesign.containerPaddingLeftRight,
      child: Row(
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
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => RedeemByInputCodePage(
                    voucherDesignName: voucherDetailsResponse.voucherDesignName,
                  ),
                  fullscreenDialog: true,
                ),
              );
            },
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
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => RedeemByScanQrCodePage(
                    voucherDesignName: voucherDetailsResponse.voucherDesignName,
                  ),
                  fullscreenDialog: true,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _constructDownloadWidgets() {
    final _isCoupon = widget.voucherType == VoucherTypeEnum.coupon;
    final _buttonText = _isCoupon ? "Download" : "Add To Cart";

    return Padding(
      padding: ThemeDesign.containerPaddingLeftRight,
      child: SizedBox(
        width: double.infinity,
        child: RaisedButton(
          child: Text(
            _buttonText,
            style: TextStyle(
              fontSize: ThemeDesign.buttonFontSize,
            ),
          ),
          padding: EdgeInsets.all(20),
          textColor: ThemeDesign.buttonTextPrimaryColor,
          color: ThemeDesign.buttonPrimaryColor,
          onPressed: () async {
            if (_isCoupon) {
              CustomProgressDialog.show(context);
              final int _userID =
                  (await CustomSharedPreferences.getValue(StorageEnum.userID))
                      .toInt();
              var _voucherDownloadRequest = VoucherDownloadRequest(
                  widget.voucherDesignID,
                  _userID,
                  AppSetting.methodDownloadFromApp);
              var _voucherDownloadResponse =
                  await VoucherApis.voucherDownloadApi(_voucherDownloadRequest);
              CustomProgressDialog.hide(context);

              if (_voucherDownloadResponse.isSuccess) {
                CustomAlertDialog.showSuccess(
                    context, "Coupon successfully redeemed!");
              } else {
                CustomAlertDialog.showError(
                    context, _voucherDownloadResponse.error);
              }
            } else {
              CustomProgressDialog.show(context);
              final int _userID =
                  (await CustomSharedPreferences.getValue(StorageEnum.userID))
                      .toInt();
              var _cartAddRequest =
                  CartAddRequest(widget.voucherDesignID, _userID);
              var _cartAddResponse = await CartApis.addApi(_cartAddRequest);
              CustomProgressDialog.hide(context);

              if (_cartAddResponse.error.isStringEmpty()) {
                CustomAlertDialog.showSuccess(
                    context, "Voucher added to cart successfully!");
              } else {
                CustomAlertDialog.showError(context, _cartAddResponse.error);
              }
            }
          },
        ),
      ),
    );
  }
}
