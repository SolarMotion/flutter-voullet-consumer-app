import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import './../../apis/cart_apis.dart';
import './../../apis/voucher_apis.dart';
import './../../enums/generic_enums.dart';
import './../../helpers/custom_shared_preferences.dart';
import './../../helpers/extension_functions.dart';
import './../../helpers/static_functions.dart';
import './../../models/voucher_design_models.dart';
import './../../pages/shared_pages/loading_page.dart';
import './../../pages/voucher_pages/voucher_details_page.dart';
import './../../resources/app_settings.dart';
import './../../resources/theme_designs.dart';
import './../../widgets/custom_alert_dialog.dart';
import './../../widgets/custom_app_bar.dart';
import './../../widgets/custom_progress_dialog.dart';

class VoucherShowAllAvailablePage extends StatefulWidget {
  final VoucherTypeEnum voucherTypeEnum;

  VoucherShowAllAvailablePage({Key key, @required this.voucherTypeEnum}) : super(key: key);

  @override
  _VoucherShowAllAvailablePageState createState() => _VoucherShowAllAvailablePageState();
}

class _VoucherShowAllAvailablePageState extends State<VoucherShowAllAvailablePage> {
  bool _isFirstLoad = true;
  final double _radius = 15;
  final double _borderWidth = 2;
  var _voucherAvailableAllVoucherRequest = VoucherAvailableAllRequest("Voucher");
  var _voucherAvailableAllCouponRequest = VoucherAvailableAllRequest("Coupon");
  VoucherAvailableAllResponse _voucherAvailableAllVoucherResponse;
  VoucherAvailableAllResponse _voucherAvailableAllCouponResponse;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getListing(describeEnum(widget.voucherTypeEnum)),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData && !_isFirstLoad) {
          return snapshot.data;
        } else if (_isFirstLoad) {
          return Scaffold(
            appBar: CustomAppBar(),
            body: LoadingPage(),
          );
        } else {
          return snapshot.data;
        }
      },
    );
  }

  Future<Widget> _getListing(String designType) async {
    _voucherAvailableAllVoucherResponse = await VoucherApis.voucherAvailableAllApi(_voucherAvailableAllVoucherRequest);
    _voucherAvailableAllCouponResponse = await VoucherApis.voucherAvailableAllApi(_voucherAvailableAllCouponRequest);

    _isFirstLoad = false;

    final List<Tab> _myTabs = <Tab>[
      Tab(text: 'Vouchers'),
      Tab(text: 'Coupons'),
    ];
    final _initialIndex = designType.toLowerCase() == describeEnum(VoucherTypeEnum.voucher) ? 0 : 1;

    return Scaffold(
      body: DefaultTabController(
        initialIndex: _initialIndex,
        length: _myTabs.length,
        child: Scaffold(
          appBar: AppBar(
            brightness: Brightness.dark,
            iconTheme: IconThemeData(
              color: ThemeDesign.appPrimaryColor900,
            ),
            backgroundColor: Colors.white,
            title: Text(
              "Quill City Mall",
              style: TextStyle(
                color: ThemeDesign.appPrimaryColor900,
                fontSize: ThemeDesign.titleFontSize,
              ),
            ),
            bottom: TabBar(
              isScrollable: false,
              indicatorWeight: 3,
              indicatorColor: ThemeDesign.appPrimaryColor900,
              labelColor: ThemeDesign.appPrimaryColor900,
              unselectedLabelColor: Colors.black,
              labelStyle: TextStyle(fontSize: ThemeDesign.titleFontSize),
              unselectedLabelStyle: TextStyle(fontSize: ThemeDesign.titleFontSize),
              tabs: _myTabs,
            ),
          ),
          body: TabBarView(
            children: _myTabs.map(
              (Tab tab) {
                return tab.text.toLowerCase() == _myTabs[0].text.toLowerCase()
                    ? _constructVoucherList(_voucherAvailableAllVoucherResponse.voucherItems)
                    : _constructCouponList(_voucherAvailableAllCouponResponse.voucherItems);
              },
            ).toList(),
          ),
        ),
      ),
    );
  }

  Widget _constructEmptyText() {
    return Center(
      child: Text(
        "No items available",
        style: ThemeDesign.emptyStyle,
      ),
    );
  }

  Widget _constructVoucherList(List<VoucherDesignModel> voucherDesignItems) {
    return voucherDesignItems.isListEmpty()
        ? _constructEmptyText()
        : Container(
            padding: ThemeDesign.containerPaddingLeftRightBottom,
            child: RefreshIndicator(
              onRefresh: () async {
                final _refreshedVoucherAvailableAllVoucherResponse = await VoucherApis.voucherAvailableAllApi(_voucherAvailableAllVoucherRequest);

                setState(() {
                  _voucherAvailableAllVoucherResponse = _refreshedVoucherAvailableAllVoucherResponse;
                });
              },
              child: SingleChildScrollView(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: voucherDesignItems.length,
                  itemBuilder: (context, index) {
                    final _voucherDesignItem = voucherDesignItems[index];

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
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(_radius), bottomLeft: Radius.circular(_radius)),
                                  child: Image.memory(
                                    _voucherDesignItem.voucherDesignImageBytes,
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
                                        _voucherDesignItem.orgName,
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
                                        "Valid until ${_voucherDesignItem.validUntilDate ?? ""}",
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
                                        Share.text("Hello", "${_voucherDesignItem.voucherDesignUrl}${_voucherDesignItem.voucherDesignID}", 'text/plain');
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
                                      child: Image.asset('assets/icons/icon_cart_corner.png', width: 60),
                                    ),
                                  ),
                                  onTap: () async {
                                    CustomProgressDialog.show(context);
                                    final int _userID = (await CustomSharedPreferences.getValue(StorageEnum.userID)).toInt();
                                    var _cartAddRequest = CartAddRequest(_voucherDesignItem.voucherDesignID, _userID);
                                    var _voucherDownloadResponse = await CartApis.addApi(_cartAddRequest);
                                    CustomProgressDialog.hide(context);

                                    if (_voucherDownloadResponse.error.isStringEmpty()) {
                                      CustomAlertDialog.showSuccess(context, "Voucher added to cart successfully!");
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
                                  voucherDesignID: _voucherDesignItem.voucherDesignID,
                                  redeemType: ButtonTypeEnum.download,
                                  voucherType: VoucherTypeEnum.voucher,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
  }

  Widget _constructCouponList(List<VoucherDesignModel> couponDesignItems) {
    return couponDesignItems.isListEmpty()
        ? _constructEmptyText()
        : Container(
            padding: ThemeDesign.containerPaddingLeftRightBottom,
            child: RefreshIndicator(
              onRefresh: () async {
                final _refreshedVoucherAvailableAllCouponResponse = await VoucherApis.voucherAvailableAllApi(_voucherAvailableAllCouponRequest);
                setState(() {
                  _voucherAvailableAllCouponResponse = _refreshedVoucherAvailableAllCouponResponse;
                });
              },
              child: SingleChildScrollView(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: couponDesignItems.length,
                  itemBuilder: (context, index) {
                    final _couponDesignItem = couponDesignItems[index];

                    return Container(
                      height: StaticFunctions.getDeviceHeight(context) * 0.35,
                      child: Card(
                        elevation: 5,
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
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(_radius), bottomLeft: Radius.circular(_radius)),
                                  child: Image.memory(
                                    _couponDesignItem.voucherDesignImageBytes,
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
                                        _couponDesignItem.orgName,
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
                                        "Valid until ${_couponDesignItem.validUntilDate ?? ""}",
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
                                        Share.text("Hello", "${_couponDesignItem.voucherDesignUrl}${_couponDesignItem.voucherDesignID}", 'text/plain');
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
                                    var _voucherDownloadRequest = VoucherDownloadRequest(_couponDesignItem.voucherDesignID, _userID, AppSetting.methodDownloadFromApp);
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
                                  voucherDesignID: _couponDesignItem.voucherDesignID,
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
                ),
              ),
            ),
          );
  }
}
