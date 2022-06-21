import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';

import '../../apis/generic_apis.dart';
import "../../helpers/custom_drop_down_button_listings.dart";
import './../../apis/voucher_apis.dart';
import './../../enums/generic_enums.dart';
import './../../helpers/custom_shared_preferences.dart';
import './../../helpers/extension_functions.dart';
import './../../helpers/static_functions.dart';
import './../../pages/shared_pages/error_page.dart';
import './../../pages/shared_pages/loading_page.dart';
import './../../pages/voucher_pages/voucher_details_page.dart';
import './../../resources/theme_designs.dart';
import './../../widgets/custom_alert_dialog.dart';
import './../../widgets/custom_app_bar.dart';
import './../../widgets/custom_progress_dialog.dart';
import './../../widgets/custom_sized_box.dart';

class VoucherIndexPage extends StatefulWidget {
  @override
  _VoucherIndexPageState createState() => _VoucherIndexPageState();
}

class _VoucherIndexPageState extends State<VoucherIndexPage> {
  Future<VoucherGetUserVoucherResponse> _voucherGetUserVoucherResponse;
  TextEditingController _searchController = TextEditingController();
  final String _title = "Vouchers";
  String _filter = "";
  bool _isFirstLoad = true;
  int _userID;

  @override
  void initState() {
    super.initState();

    _voucherGetUserVoucherResponse = getUserVouchers();
  }

  Future<VoucherGetUserVoucherResponse> getUserVouchers() async {
    _userID = (await CustomSharedPreferences.getValue(StorageEnum.userID)).toInt();
    VoucherGetUserVoucherRequest _voucherGetUserVoucherRequest = VoucherGetUserVoucherRequest(_userID, null);

    var _result = await VoucherApis.voucherGetUserVoucherApi(_voucherGetUserVoucherRequest);

    return _result;
  }

  @override
  Widget build(BuildContext context) {
    final _voucherSortings = CustomDropDownButtonListing.voucherSorting();
    final _deviceHeight = StaticFunctions.getDeviceHeight(context);
    final _imageHeight = _deviceHeight * ThemeDesign.voucherImageHeightRatio;
    final _imageWidth = StaticFunctions.getDeviceWidth(context) * ThemeDesign.voucherImageWidthRatio;

    return FutureBuilder(
      future: _voucherGetUserVoucherResponse,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting && _isFirstLoad) {
          return Scaffold(
            appBar: CustomAppBar(title: _title),
            body: LoadingPage(),
          );
        } else if (snapshot.hasError) {
          return ErrorPage(text: "${snapshot.error}");
        } else {
          VoucherGetUserVoucherResponse _response = snapshot.data;
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
                                onChanged: (value) {
                                  setState(() {
                                    _filter = value ?? "";
                                  });
                                },
                                controller: _searchController,
                                decoration: InputDecoration(
                                  labelText: "Search",
                                  hintText: "Voucher name...",
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
                                onChanged: (_) {},
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
                                _voucherGetUserVoucherResponse = getUserVouchers();
                                _searchController.text = "";
                              });
                            },
                            child: _response.voucherItems.isListEmpty()
                                ? constructEmptyVoucher()
                                : ListView.builder(
                                    physics: AlwaysScrollableScrollPhysics(),
                                    itemCount: _response.voucherItems.length,
                                    itemBuilder: (context, index) {
                                      var _voucherItem = _response.voucherItems[index];

                                      if (_filter.isStringEmpty() ||
                                          (!_filter.isStringEmpty() &&
                                              _voucherItem.voucherDesignName
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
                                                      _voucherItem.voucherDesignImageBytes,
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
                                                            _voucherItem.voucherDesignName,
                                                            style: ThemeDesign.titleStyleWithColourRegular,
                                                            maxLines: 5,
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                          CustomSizedBox(height: 10),
                                                          Text(
                                                            "Valid Until ${_voucherItem.validUntilDate ?? ""}",
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
                                                                      "${_voucherItem.voucherDesignUrl}${_voucherItem.voucherDesignID}",
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
                                                                  final _deleteResult =
                                                                      await displayDeleteVoucherDialog(
                                                                          context, _voucherItem.voucherDesignName);

                                                                  if (_deleteResult == AlertDialogResultEnum.success) {
                                                                    CustomProgressDialog.show(context);
                                                                    final _voucherDeleteUserVoucherRequest =
                                                                        VoucherDeleteUserVoucherRequest(
                                                                            _voucherItem.voucherID, _userID);
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
                                                                        _voucherGetUserVoucherResponse =
                                                                            getUserVouchers();
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
                                                  voucherID: _voucherItem.voucherID,
                                                  voucherDesignID: _voucherItem.voucherDesignID,
                                                  redeemType: ButtonTypeEnum.redeem,
                                                  voucherType: VoucherTypeEnum.voucher,
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

  Future<AlertDialogResultEnum> displayDeleteVoucherDialog(BuildContext context, String voucherName) async {
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
              Text("Are you sure you want to delete $voucherName voucher?"),
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

  Widget constructEmptyVoucher() {
    return Center(
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: <Widget>[
            Image.asset("assets/pictures/record_empty.png"),
            CustomSizedBox(height: 5),
            Text(
              "No Voucher Record",
              style: ThemeDesign.emptyStyle,
            ),
          ],
        ),
      ),
    );
  }
}
