import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';

import './../../apis/highlight_apis.dart';
import './../../apis/voucher_apis.dart';
import './../../enums/generic_enums.dart';
import './../../helpers/custom_shared_preferences.dart';
import './../../helpers/extension_functions.dart';
import './../../helpers/static_functions.dart';
import './../../models/voucher_design_models.dart';
import './../../pages/shared_pages/loading_page.dart';
import './../../resources/app_settings.dart';
import './../../resources/theme_designs.dart';
import './../../widgets/custom_alert_dialog.dart';
import './../../widgets/custom_app_bar.dart';
import './../../widgets/custom_progress_dialog.dart';
import './../../widgets/custom_sized_box.dart';
import './../../pages/voucher_pages/voucher_details_page.dart';

class HighlightIndexPage extends StatefulWidget {
  @override
  _HighlightIndexPageState createState() => _HighlightIndexPageState();
}

class _HighlightIndexPageState extends State<HighlightIndexPage> {
  final double _radius = 15;
  final double _borderWidth = 2;
  final String _title = "Highlights";
  bool _isFirstLoad = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getHighlightDetails(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData && !_isFirstLoad) {
          return snapshot.data;
        } else if (_isFirstLoad) {
          return Scaffold(
            appBar: CustomAppBar(
              title: _title,
            ),
            body: LoadingPage(),
          );
        } else {
          return snapshot.data;
        }
      },
    );
  }

  Future<Widget> _getHighlightDetails() async {
    HighlightResponse _highlightResponse = await HighlightApis.highlightApi();
    _isFirstLoad = false;

    return Scaffold(
      appBar: CustomAppBar(
        title: _title,
      ),
      body: Container(
        child: RefreshIndicator(
          onRefresh: () async {
            final _refreshedhighlightResponse = await HighlightApis.highlightApi();

            setState(() {
              _highlightResponse = _refreshedhighlightResponse;
            });
          },
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: ThemeDesign.containerPaddingAll,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Popular Trending", style: ThemeDesign.titleStyleWithColourLarge),
                _highlightResponse.popularItems.isListEmpty()
                    ? _constructEmptyText()
                    : _constructPopularList(_highlightResponse.popularItems),
                CustomSizedBox(height: 40),
                Text("Happenings", style: ThemeDesign.titleStyleWithColourLarge),
                _highlightResponse.newItems.isListEmpty()
                    ? _constructEmptyText()
                    : _constructNewList(_highlightResponse.newItems),
                CustomSizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _constructEmptyText() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Text(
        "No items available",
        style: ThemeDesign.emptyStyle,
      ),
    );
  }

  Widget _constructPopularList(List<VoucherDesignModel> popularItems) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: popularItems.length,
      itemBuilder: (context, index) {
        final _popularItem = popularItems[index];

        return Container(
          height: StaticFunctions.getDeviceHeight(context) * 0.35,
          child: Card(
            shape: RoundedRectangleBorder(
              side: BorderSide(color: ThemeDesign.appPrimaryColor900, width: _borderWidth),
              borderRadius: BorderRadius.circular(_radius),
            ),
            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(_radius), bottomLeft: Radius.circular(_radius)),
                      child: Image.memory(
                        _popularItem.voucherDesignImageBytes,
                        width: StaticFunctions.getDeviceWidth(context) * 0.4,
                        height: StaticFunctions.getDeviceHeight(context) * 0.35,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 150,
                          child: Text(
                            _popularItem.orgName,
                            style: TextStyle(
                              color: ThemeDesign.appPrimaryColor900,
                              fontWeight: FontWeight.bold,
                              fontSize: ThemeDesign.descriptionFontSize,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 5,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 150,
                          child: Text(
                            "Valid until ${_popularItem.validUntilDate ?? ""}",
                            style: ThemeDesign.emptyStyle,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 5,
                          ),
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          child: Container(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Image.asset('assets/icons/icon_share.png', width: 40, height: 40),
                            ),
                          ),
                          onTap: () {
                            Share.text("Hello", "${_popularItem.voucherDesignUrl}${_popularItem.voucherDesignID}",
                                'text/plain');
                          },
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: Container(
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(topRight: Radius.circular(_radius)),
                          child: Image.asset('assets/icons/icon_download_corner.png', width: 60),
                        ),
                      ),
                      onTap: () async {
                        CustomProgressDialog.show(context);
                        final int _userID = (await CustomSharedPreferences.getValue(StorageEnum.userID)).toInt();
                        var _voucherDownloadRequest = VoucherDownloadRequest(
                            _popularItem.voucherDesignID, _userID, AppSetting.methodDownloadFromApp);
                        var _voucherDownloadResponse = await VoucherApis.voucherDownloadApi(_voucherDownloadRequest);
                        CustomProgressDialog.hide(context);

                        if (_voucherDownloadResponse.isSuccess) {
                          CustomAlertDialog.showSuccess(context, "Coupon successfully redeemed!");
                        } else {
                          CustomAlertDialog.showError(context, _voucherDownloadResponse.error);
                        }
                      },
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => VoucherDetailsPage(
                      voucherDesignID: _popularItem.voucherDesignID,
                      redeemType: ButtonTypeEnum.download,
                      voucherType: VoucherTypeEnum.coupon,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _constructNewList(List<VoucherDesignModel> newItems) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, StaticFunctions.getDeviceWidth(context) * 0.048, 0, 0),
      height: StaticFunctions.getDeviceHeight(context) * 0.35,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: newItems.length,
        itemBuilder: (context, index) {
          final _newItem = newItems[index];

          return Card(
            margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
            shape: RoundedRectangleBorder(
              side: BorderSide(color: ThemeDesign.appPrimaryColor900, width: _borderWidth),
              borderRadius: BorderRadius.circular(_radius),
            ),
            child: InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(_radius),
                child: Image.memory(
                  _newItem.voucherDesignImageBytes,
                  width: StaticFunctions.getDeviceWidth(context) * 0.4,
                  fit: BoxFit.fill,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => VoucherDetailsPage(
                      voucherDesignID: _newItem.voucherDesignID,
                      redeemType: ButtonTypeEnum.download,
                      voucherType: VoucherTypeEnum.coupon,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
