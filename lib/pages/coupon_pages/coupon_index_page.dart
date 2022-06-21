import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter_voullet_consumer_app/resources/app_settings.dart';

import '../../apis/generic_apis.dart';
import '../../apis/voucher_apis.dart';
import '../../helpers/custom_drop_down_button_listings.dart';
import '../../resources/theme_designs.dart';
import './../../widgets/custom_app_bar.dart';
import './../../pages/voucher_pages/voucher_details_page.dart';
import './../../widgets/custom_alert_dialog.dart';
import './../../widgets/custom_progress_dialog.dart';
import './../../apis/voucher_apis.dart';
import './../../enums/generic_enums.dart';
import './../../helpers/custom_shared_preferences.dart';
import './../../helpers/static_functions.dart';
import './../../pages/shared_pages/error_page.dart';
import './../../pages/shared_pages/loading_page.dart';
import './../../resources/theme_designs.dart';
import './../../widgets/custom_sized_box.dart';
import './../../helpers/extension_functions.dart';

class CouponIndexPage extends StatefulWidget {
  @override
  _CouponIndexPageState createState() => _CouponIndexPageState();
}

class _CouponIndexPageState extends State<CouponIndexPage> {
  TextEditingController _searchController = TextEditingController();
  List<ListingItem> _voucherSortings;
  Future<VoucherGetUserCouponResponse> _voucherGetUserCouponResponse;
  bool _isFirstLoad = true;
  int _userID;
  final _title = "Coupons";
  String _filter = "";
  String _sortByFilter = "";
  final String _sortByLocal = describeEnum(VoucherSortByEnum.local).capitalize();

  @override
  void initState() {
    super.initState();

    _voucherSortings = CustomDropDownButtonListing.voucherSorting();
    _voucherGetUserCouponResponse = getUserCoupons();
    _sortByFilter = _voucherSortings[0].stringValue;
  }

  Future<VoucherGetUserCouponResponse> getUserCoupons() async {
    _userID = (await CustomSharedPreferences.getValue(StorageEnum.userID)).toInt();
    VoucherGetUserCouponRequest _voucherGetUserCouponRequest = VoucherGetUserCouponRequest(_userID, null);

    return await VoucherApis.voucherGetUserCouponApi(_voucherGetUserCouponRequest);
  }

  @override
  Widget build(BuildContext context) {
    final _voucherSortings = CustomDropDownButtonListing.voucherSorting();

    final _deviceHeight = StaticFunctions.getDeviceHeight(context);
    final _imageHeight = _deviceHeight * ThemeDesign.voucherImageHeightRatio;
    final _imageWidth = StaticFunctions.getDeviceWidth(context) * ThemeDesign.voucherImageWidthRatio;

    return FutureBuilder(
      future: _voucherGetUserCouponResponse,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting && _isFirstLoad) {
          return Scaffold(
            appBar: CustomAppBar(title: _title),
            body: LoadingPage(),
          );
        } else if (snapshot.hasError) {
          return ErrorPage(text: "${snapshot.error}");
        } else {
          VoucherGetUserCouponResponse _response = snapshot.data;
          _isFirstLoad = false;

          return Scaffold(
            appBar: CustomAppBar(title: _title),
            body: _response.error.isStringEmpty()
                ? Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: TextFormField(
                                controller: _searchController,
                                onChanged: (value) {
                                  setState(() {
                                    _filter = value ?? "";
                                  });
                                },
                                decoration: InputDecoration(
                                  labelText: "Search",
                                  hintText: "Coupon name...",
                                  labelStyle: TextStyle(color: ThemeDesign.appPrimaryColor900),
                                  hintStyle: TextStyle(color: ThemeDesign.appPrimaryColor900),
                                  prefixIcon: Icon(Icons.search, color: ThemeDesign.appPrimaryColor900),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: ThemeDesign.appPrimaryColor900, width: 2),
                                    borderRadius: BorderRadius.all(Radius.circular(25)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: ThemeDesign.appPrimaryColor900, width: 2),
                                    borderRadius: BorderRadius.all(Radius.circular(25)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
                        child: Row(
                          children: <Widget>[
                            Text("Sort By:", style: ThemeDesign.emptyStyle),
                            SizedBox(width: 10),
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                isExpanded: true,
                                iconSize: ThemeDesign.dropDownButtonIconSize,
                                value: _voucherSortings[0].stringValue,
                                items: _voucherSortings.map((ListingItem a) {
                                  return DropdownMenuItem<String>(
                                    value: a.stringValue,
                                    child: Text(a.text),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _sortByFilter = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(10),
                          child: RefreshIndicator(
                            onRefresh: () async {
                              setState(() {
                                _voucherGetUserCouponResponse = getUserCoupons();
                                _searchController.text = "";
                              });
                            },
                            child: _response.couponItems.isListEmpty()
                                ? _constructEmptyCoupon()
                                : ListView.builder(
                                    physics: AlwaysScrollableScrollPhysics(),
                                    itemCount: _response.couponItems.length,
                                    itemBuilder: (context, index) {
                                      var _couponItem = _response.couponItems[index];

                                      if (_sortByLocal == _sortByFilter &&
                                          _couponItem.voucherCountryName != AppSetting.currentCountry) {
                                        return Container();
                                      }

                                      if (_filter.isStringEmpty() ||
                                          (!_filter.isStringEmpty() &&
                                              _couponItem.voucherDesignName
                                                  .toUpperCase()
                                                  .contains(_filter.toUpperCase()))) {
                                        return InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          child: Container(
                                            height: _imageHeight,
                                            margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                            child: Card(
                                              elevation: 5,
                                              shape: ThemeDesign.cardBorderStyle,
                                              child: Row(
                                                children: <Widget>[
                                                  ClipRRect(
                                                    borderRadius: BorderRadius.only(
                                                      topLeft: Radius.circular(ThemeDesign.cardCornerRadius),
                                                      bottomLeft: Radius.circular(ThemeDesign.cardCornerRadius),
                                                    ),
                                                    child: Image.memory(
                                                      _couponItem.voucherDesignImageBytes,
                                                      width: _imageWidth,
                                                      height: _imageHeight,
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                  Flexible(
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: <Widget>[
                                                          Text(
                                                            _couponItem.voucherDesignName,
                                                            style: ThemeDesign.titleStyleWithColourRegular,
                                                            maxLines: 5,
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                          CustomSizedBox(height: 10),
                                                          Text(
                                                            "Valid Until ${_couponItem.validUntilDate ?? ""}",
                                                            style: ThemeDesign.emptyStyle,
                                                            maxLines: 5,
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                          Spacer(),
                                                          Row(
                                                            children: <Widget>[
                                                              InkWell(
                                                                splashColor: Colors.transparent,
                                                                focusColor: Colors.transparent,
                                                                highlightColor: Colors.transparent,
                                                                child: Container(
                                                                  child: ClipRRect(
                                                                    borderRadius: BorderRadius.circular(20),
                                                                    child: Image.asset('assets/icons/icon_share.png',
                                                                        width: 40, height: 40),
                                                                  ),
                                                                ),
                                                                onTap: () {
                                                                  Share.text(
                                                                      "Hello",
                                                                      "${_couponItem.voucherDesignUrl}${_couponItem.voucherDesignID}",
                                                                      'text/plain');
                                                                },
                                                              ),
                                                              SizedBox(width: 10),
                                                              InkWell(
                                                                splashColor: Colors.transparent,
                                                                focusColor: Colors.transparent,
                                                                highlightColor: Colors.transparent,
                                                                child: Container(
                                                                  child: ClipRRect(
                                                                    borderRadius: BorderRadius.circular(20),
                                                                    child: Image.asset(
                                                                      'assets/icons/icon_delete.png',
                                                                      width: 40,
                                                                      height: 40,
                                                                    ),
                                                                  ),
                                                                ),
                                                                onTap: () async {
                                                                  final _deleteResult = await displayDeleteCouponDialog(
                                                                      context, _couponItem.voucherDesignName);

                                                                  if (_deleteResult == AlertDialogResultEnum.success) {
                                                                    CustomProgressDialog.show(context);
                                                                    final _voucherDeleteUserVoucherRequest =
                                                                        VoucherDeleteUserVoucherRequest(
                                                                            _couponItem.voucherID, _userID);
                                                                    final _voucherDeleteUserVoucherResponse =
                                                                        await VoucherApis.voucherDeleteUserVoucherApi(
                                                                            _voucherDeleteUserVoucherRequest);
                                                                    CustomProgressDialog.hide(context);

                                                                    if (!_voucherDeleteUserVoucherResponse.error
                                                                        .isStringEmpty()) {
                                                                      CustomAlertDialog.showError(context,
                                                                          _voucherDeleteUserVoucherResponse.error);
                                                                    } else {
                                                                      setState(() {
                                                                        _voucherGetUserCouponResponse =
                                                                            getUserCoupons();
                                                                      });
                                                                    }
                                                                  }
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                      padding: EdgeInsets.only(right: 8),
                                                      child: Align(
                                                        alignment: Alignment.center,
                                                        child: Image.asset(
                                                          'assets/icons/icon_right_arrow.png',
                                                          width: 40,
                                                          height: 40,
                                                        ),
                                                      ))
                                                ],
                                              ),
                                            ),
                                          ),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (BuildContext context) => VoucherDetailsPage(
                                                  voucherID: _couponItem.voucherID,
                                                  voucherDesignID: _couponItem.voucherDesignID,
                                                  redeemType: ButtonTypeEnum.redeem,
                                                  voucherType: VoucherTypeEnum.coupon,
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      }

                                      return Container();
                                    },
                                  ),
                          ),
                        ),
                      ),
                    ],
                  )
                : ErrorPage(text: _response.error),
          );
        }
      },
    );
  }

  Future<AlertDialogResultEnum> displayDeleteCouponDialog(BuildContext context, String couponName) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Delete',
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("Are you sure you want to delete $couponName coupon?"),
              CustomSizedBox(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: OutlineButton(
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          fontSize: ThemeDesign.buttonFontSize,
                        ),
                      ),
                      padding: EdgeInsets.all(20),
                      textColor: ThemeDesign.buttonTextSecondaryColor,
                      color: ThemeDesign.buttonSecondaryColor,
                      highlightedBorderColor: ThemeDesign.buttonTextSecondaryColor,
                      borderSide: BorderSide(
                        color: ThemeDesign.buttonTextSecondaryColor,
                        width: 2,
                      ),
                      onPressed: () {
                        Navigator.pop(context, AlertDialogResultEnum.error);
                      },
                    ),
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    child: RaisedButton(
                      child: Text(
                        "OK",
                        style: TextStyle(
                          fontSize: ThemeDesign.buttonFontSize,
                        ),
                      ),
                      padding: EdgeInsets.all(20),
                      textColor: ThemeDesign.buttonTextPrimaryColor,
                      color: ThemeDesign.buttonPrimaryColor,
                      onPressed: () {
                        Navigator.pop(context, AlertDialogResultEnum.success);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _constructEmptyCoupon() {
    return Center(
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: <Widget>[
            Image.asset("assets/pictures/record_empty.png"),
            CustomSizedBox(height: 5),
            Text(
              "No Coupon Record",
              style: ThemeDesign.emptyStyle,
            ),
          ],
        ),
      ),
    );
  }
}
