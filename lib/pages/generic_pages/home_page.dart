import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import './../../apis/cart_apis.dart';
import './../../apis/voucher_apis.dart';
import './../../enums/generic_enums.dart';
import './../../helpers/custom_shared_preferences.dart';
import './../../helpers/extension_functions.dart';
import './../../helpers/static_functions.dart';
import './../../models/voucher_design_models.dart';
import './../../pages/bulletin_pages/bulletin_details_page.dart';
import './../../pages/shared_pages/loading_page.dart';
import './../../pages/voucher_pages/voucher_details_page.dart';
import './../../pages/voucher_pages/voucher_show_all_available_page.dart';
import './../../resources/theme_designs.dart';
import './../../widgets/custom_alert_dialog.dart';
import './../../widgets/custom_app_bar.dart';
import './../../widgets/custom_progress_dialog.dart';
import './../../widgets/custom_sized_box.dart';
import './../../apis/bulletin_apis.dart';
import './../../resources/app_settings.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _detailsWidth;
  bool _isFirstLoad = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _detailsWidth = StaticFunctions.getDeviceWidth(context) * 0.35;

    return FutureBuilder(
      future: _getHomeDetails(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData && !_isFirstLoad) {
          return snapshot.data;
        } else if (_isFirstLoad) {
          return Scaffold(
            appBar: CustomAppBar(
              showHighlight: true,
            ),
            body: LoadingPage(),
          );
        } else {
          return snapshot.data;
        }
      },
    );
  }

  Future<Widget> _getHomeDetails() async {
    try {
      BulletinImageSlideResponse _bulletinImageSlideResponse = await BulletinApis.bulletinImageSlideApi();
      VoucherAvailableResponse _voucherAvailableResponse = await VoucherApis.voucherAvailableApi();
      _isFirstLoad = false;

      return Scaffold(
        appBar: CustomAppBar(
          showHighlight: true,
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            final _refreshedBulletinImageSlideResponse = await BulletinApis.bulletinImageSlideApi();
            final _refreshedVoucherAvailableResponse = await VoucherApis.voucherAvailableApi();

            setState(() {
              _bulletinImageSlideResponse = _refreshedBulletinImageSlideResponse;
              _voucherAvailableResponse = _refreshedVoucherAvailableResponse;
            });
          },
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: ThemeDesign.containerPaddingTopBottom,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _bulletinImageSlideResponse.items.isListEmpty()
                    ? Container()
                    : _constructBulletinImageSlide(_bulletinImageSlideResponse.items),
                _bulletinImageSlideResponse.items.isListEmpty() ? Container() : CustomSizedBox(),
                Padding(
                  padding: ThemeDesign.containerPaddingLeftRight,
                  child: _constructShowAll("Vouchers", VoucherTypeEnum.voucher),
                ),
                Padding(
                  padding: ThemeDesign.containerPaddingLeftRight,
                  child: _voucherAvailableResponse.voucherItems.isListEmpty()
                      ? _constructEmptyText()
                      : _constructVoucherList(_voucherAvailableResponse.voucherItems),
                ),
                CustomSizedBox(height: 40),
                Padding(
                  padding: ThemeDesign.containerPaddingLeftRight,
                  child: _constructShowAll("Coupons", VoucherTypeEnum.coupon),
                ),
                Padding(
                  padding: ThemeDesign.containerPaddingLeftRight,
                  child: _voucherAvailableResponse.couponItems.isListEmpty()
                      ? _constructEmptyText()
                      : _constructCouponList(_voucherAvailableResponse.couponItems),
                ),
                CustomSizedBox(),
              ],
            ),
          ),
        ),
      );
    } catch (e) {
      print(e);
      throw e;
    }
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

  Widget _constructVoucherList(List<VoucherDesignModel> voucherDesignItems) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: voucherDesignItems.length,
      itemBuilder: (context, index) {
        final _voucherDesignItem = voucherDesignItems[index];

        return Container(
          height: StaticFunctions.getDeviceHeight(context) * ThemeDesign.voucherImageHeightRatio,
          child: Card(
            elevation: 5,
            shape: ThemeDesign.cardBorderStyle,
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
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(ThemeDesign.cardCornerRadius),
                        bottomLeft: Radius.circular(ThemeDesign.cardCornerRadius),
                      ),
                      child: Image.memory(
                        _voucherDesignItem.voucherDesignImageBytes,
                        width: StaticFunctions.getDeviceWidth(context) * 0.4,
                        height: StaticFunctions.getDeviceHeight(context) * ThemeDesign.voucherImageHeightRatio,
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
                          width: _detailsWidth,
                          child: Text(
                            _voucherDesignItem.orgName,
                            style: ThemeDesign.titleStyleWithColourRegular,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 5,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: _detailsWidth,
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
                        padding: const EdgeInsets.all(8),
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          child: Container(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset('assets/icons/icon_share.png', width: 40, height: 40),
                            ),
                          ),
                          onTap: () {
                            Share.text(
                                "Hello",
                                "${_voucherDesignItem.voucherDesignUrl}${_voucherDesignItem.voucherDesignID}",
                                'text/plain');
                          },
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: Container(
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(topRight: Radius.circular(ThemeDesign.cardCornerRadius)),
                          child: Image.asset('assets/icons/icon_cart_corner.png', width: 60),
                        ),
                      ),
                      onTap: () async {
                        CustomProgressDialog.show(context);
                        final int _userID = (await CustomSharedPreferences.getValue(StorageEnum.userID)).toInt();
                        var _cartAddRequest = CartAddRequest(_voucherDesignItem.voucherDesignID, _userID);
                        var _cartAddResponse = await CartApis.addApi(_cartAddRequest);
                        CustomProgressDialog.hide(context);

                        if (_cartAddResponse.error.isStringEmpty()) {
                          CustomAlertDialog.showSuccess(context, "Voucher added to cart successfully!");
                        } else {
                          CustomAlertDialog.showError(context, _cartAddResponse.error);
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
    );
  }

  Widget _constructCouponList(List<VoucherDesignModel> couponDesignItems) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: couponDesignItems.length,
      itemBuilder: (context, index) {
        final _couponDesignItem = couponDesignItems[index];

        return Container(
          height: StaticFunctions.getDeviceHeight(context) * ThemeDesign.voucherImageHeightRatio,
          child: Card(
            elevation: 5,
            shape: ThemeDesign.cardBorderStyle,
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
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(ThemeDesign.cardCornerRadius),
                        bottomLeft: Radius.circular(ThemeDesign.cardCornerRadius),
                      ),
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
                          width: _detailsWidth,
                          child: Text(
                            _couponDesignItem.orgName,
                            style: ThemeDesign.titleStyleWithColourRegular,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 5,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: _detailsWidth,
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
                            Share.text(
                                "Hello",
                                "${_couponDesignItem.voucherDesignUrl}${_couponDesignItem.voucherDesignID}",
                                'text/plain');
                          },
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: Container(
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(topRight: Radius.circular(ThemeDesign.cardCornerRadius)),
                          child: Image.asset('assets/icons/icon_download_corner.png', width: 60),
                        ),
                      ),
                      onTap: () async {
                        CustomProgressDialog.show(context);
                        final int _userID = (await CustomSharedPreferences.getValue(StorageEnum.userID)).toInt();
                        var _voucherDownloadRequest = VoucherDownloadRequest(
                            _couponDesignItem.voucherDesignID, _userID, AppSetting.methodDownloadFromApp);
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
    );
  }

  Widget _constructBulletinImageSlide(List<BulletinImageSlideItem> bulletinImageSlideItem) {
    final _slideWidth = StaticFunctions.getDeviceWidth(context);
    final _slideHeight = StaticFunctions.getDeviceHeight(context) / 3.5;

    return ConstrainedBox(
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            child: Image.memory(
              bulletinImageSlideItem[index].imageBytes,
              fit: BoxFit.fill,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => BulletinDetailsPage(
                    bulletinDetails: bulletinImageSlideItem[index],
                    slideHeight: _slideHeight,
                    slideWidth: _slideWidth,
                  ),
                ),
              );
            },
          );
        },
        itemCount: bulletinImageSlideItem.length,
        viewportFraction: 0.8,
        scale: 0.9,
        autoplay: true,
        autoplayDelay: 5000,
        pagination: SwiperPagination(),
      ),
      constraints: BoxConstraints.loose(
        Size(
          _slideWidth,
          _slideHeight,
        ),
      ),
    );
  }

  Widget _constructShowAll(String title, VoucherTypeEnum voucherTypeEnum) {
    return InkWell(
      child: Row(
        children: <Widget>[
          Text(
            title,
            style: ThemeDesign.titleStyleWithColourLarge,
          ),
          Spacer(),
          Text(
            "Show All",
            style: TextStyle(
              fontSize: ThemeDesign.descriptionFontSize,
              color: ThemeDesign.appPrimaryColor,
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: ThemeDesign.appPrimaryColor,
          ),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => VoucherShowAllAvailablePage(
              voucherTypeEnum: voucherTypeEnum,
            ),
          ),
        );
      },
    );
  }
}
