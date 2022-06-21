import 'package:flutter/material.dart';

import './../../apis/cart_apis.dart';
import './../../enums/generic_enums.dart';
import './../../helpers/custom_shared_preferences.dart';
import './../../helpers/extension_functions.dart';
import './../../helpers/static_functions.dart';
import './../../pages/cart_pages/cart_checkout_page.dart';
import './../../pages/shared_pages/empty_page.dart';
import './../../pages/shared_pages/error_page.dart';
import "./../../pages/shared_pages/loading_page.dart";
import './../../pages/voucher_pages/voucher_details_page.dart';
import './../../resources/theme_designs.dart';
import './../../widgets/custom_alert_dialog.dart';
import './../../widgets/custom_app_bar.dart';
import './../../widgets/custom_progress_dialog.dart';
import './../../widgets/custom_sized_box.dart';

class CartIndexPage extends StatefulWidget {
  @override
  _CartIndexPageState createState() => _CartIndexPageState();
}

class _CartIndexPageState extends State<CartIndexPage> {
  Future<CartGetResponse> _cartGetResponse;
  int _userID;
  bool _isFirstLoad = true;
  bool _isDeleteMode = false;
  double _totalAmount = 0.00;

  @override
  void initState() {
    super.initState();

    _cartGetResponse = getCartDetails();
  }

  Future<CartGetResponse> getCartDetails() async {
    _userID = (await CustomSharedPreferences.getValue(StorageEnum.userID)).toInt();
    CartGetRequest _cartGetRequest = CartGetRequest(_userID);

    return await CartApis.getApi(_cartGetRequest);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _cartGetResponse,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting && _isFirstLoad) {
          return Scaffold(
            appBar: CustomAppBar(
              showHighlight: true,
            ),
            body: LoadingPage(),
          );
        } else if (snapshot.hasError) {
          return ErrorPage(text: "${snapshot.error}");
        } else {
          final CartGetResponse _response = snapshot.data;
          final _deviceHeight = StaticFunctions.getDeviceHeight(context);
          final _imageHeight = _deviceHeight * 0.1;
          _isFirstLoad = false;

          _totalAmount = _response.cartVoucherDesignItems
              .where((a) => a.isSelected)
              .map((e) => e.voucherDesignPrice)
              .toList()
              .fold<double>(0, (previousValue, element) => previousValue + element);

          return Scaffold(
            appBar: CustomAppBar(
              showHighlight: true,
            ),
            body: _response.error.isStringEmpty()
                ? Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerRight,
                        child: FlatButton(
                          child: Text(
                            _isDeleteMode ? "Complete" : "Delete",
                            style: TextStyle(fontSize: ThemeDesign.buttonFontSize),
                          ),
                          textColor: Colors.grey,
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onPressed: _response.cartVoucherDesignItems.isListEmpty()
                              ? null
                              : () {
                                  setState(() {
                                    _isDeleteMode = !_isDeleteMode;
                                  });
                                },
                        ),
                      ),
                      constructHorizontalLine(),
                      Spacer(),
                      _response.cartVoucherDesignItems.isListEmpty()
                          ? EmptyPage(text: "Cart is empty")
                          : Container(
                              margin: EdgeInsets.all(10),
                              height: _deviceHeight * 0.57,
                              child: RefreshIndicator(
                                onRefresh: () async {
                                  setState(() {
                                    _cartGetResponse = getCartDetails();
                                  });
                                },
                                child: ListView.builder(
                                  physics: AlwaysScrollableScrollPhysics(),
                                  itemCount: _response.cartVoucherDesignItems.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                      width: double.infinity,
                                      child: Card(
                                        elevation: 5,
                                        shape: ThemeDesign.cardBorderStyle,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Row(
                                            children: <Widget>[
                                              Checkbox(
                                                value: _response.cartVoucherDesignItems[index].isSelected,
                                                onChanged: (bool value) async {
                                                  setState(() {
                                                    _response.cartVoucherDesignItems[index].isSelected = value;
                                                  });

                                                  final _cartToggleRequest = CartToggleRequest(
                                                    _response.cartVoucherDesignItems[index].voucherDesignID,
                                                    true,
                                                    false,
                                                    _userID,
                                                  );
                                                  CartToggleResponse _cartToggleResponse =
                                                      await CartApis.toggleApi(_cartToggleRequest);

                                                  if (!_cartToggleResponse.error.isStringEmpty()) {
                                                    CustomAlertDialog.showError(context, _cartToggleResponse.error);
                                                  }
                                                },
                                              ),
                                              InkWell(
                                                child: Padding(
                                                  padding: const EdgeInsets.fromLTRB(5, 0, 15, 0),
                                                  child: Image.memory(
                                                    _response.cartVoucherDesignItems[index].voucherDesignImageBytes,
                                                    width: _imageHeight,
                                                    height: _imageHeight,
                                                  ),
                                                ),
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (BuildContext context) => VoucherDetailsPage(
                                                        voucherDesignID:
                                                            _response.cartVoucherDesignItems[index].voucherDesignID,
                                                        redeemType: ButtonTypeEnum.download,
                                                        voucherType: VoucherTypeEnum.voucher,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                              Flexible(
                                                child: InkWell(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      Text(
                                                        _response.cartVoucherDesignItems[index].voucherDesignName,
                                                        style: ThemeDesign.titleStyleWithColourRegular,
                                                        maxLines: 5,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                      CustomSizedBox(height: 10),
                                                      Text(_response.cartVoucherDesignItems[index].voucherDescription),
                                                      CustomSizedBox(height: 10),
                                                      Text(_response.cartVoucherDesignItems[index].voucherDesignPrice
                                                          .toCurrency()),
                                                    ],
                                                  ),
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (BuildContext context) => VoucherDetailsPage(
                                                          voucherDesignID:
                                                              _response.cartVoucherDesignItems[index].voucherDesignID,
                                                          redeemType: ButtonTypeEnum.download,
                                                          voucherType: VoucherTypeEnum.voucher,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                      Spacer(),
                      constructHorizontalLine(),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Checkbox(
                                value: _response.cartVoucherDesignItems.isListEmpty()
                                    ? false
                                    : _response.cartVoucherDesignItems.every((a) => a.isSelected),
                                onChanged: _response.cartVoucherDesignItems.isListEmpty()
                                    ? null
                                    : (bool value) async {
                                        setState(() {
                                          _response.cartVoucherDesignItems.forEach((a) {
                                            a.isSelected = value;
                                          });
                                        });

                                        final _cartToggleRequest = CartToggleRequest(
                                          0,
                                          false,
                                          value,
                                          _userID,
                                        );
                                        CartToggleResponse _cartToggleResponse =
                                            await CartApis.toggleApi(_cartToggleRequest);

                                        if (!_cartToggleResponse.error.isStringEmpty()) {
                                          CustomAlertDialog.showError(context, _cartToggleResponse.error);
                                        }
                                      }),
                            Text("All", style: ThemeDesign.descriptionStyle),
                            Spacer(),
                            Text("Total: ${_totalAmount.toCurrency()}", style: ThemeDesign.descriptionStyle),
                            Spacer(),
                            RaisedButton(
                              child: Text(
                                _isDeleteMode ? "Delete" : "Checkout",
                                style: TextStyle(
                                  fontSize: ThemeDesign.buttonFontSize,
                                ),
                              ),
                              padding: EdgeInsets.all(10),
                              textColor: ThemeDesign.buttonTextPrimaryColor,
                              color: ThemeDesign.buttonPrimaryColor,
                              onPressed: _response.cartVoucherDesignItems.any((a) => a.isSelected) == false
                                  ? null
                                  : () async {
                                      if (_isDeleteMode) {
                                        final _deleteResult = await displayDeleteDialog(context);

                                        if (_deleteResult == AlertDialogResultEnum.success) {
                                          CustomProgressDialog.show(context);
                                          final int _userID =
                                              (await CustomSharedPreferences.getValue(StorageEnum.userID)).toInt();
                                          final _cartRemoveRequest = CartRemoveRequest(_userID);
                                          final _cartRemoveResponse = await CartApis.removeApi(_cartRemoveRequest);
                                          CustomProgressDialog.hide(context);

                                          if (!_cartRemoveResponse.error.isStringEmpty()) {
                                            CustomAlertDialog.showError(context, _cartRemoveResponse.error);
                                          } else {
                                            setState(() {
                                              _cartGetResponse = getCartDetails();
                                            });
                                          }
                                        }
                                      } else {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (BuildContext context) => CartCheckoutPage(),
                                            fullscreenDialog: true,
                                          ),
                                        ).then((value) {
                                          setState(() {
                                            _cartGetResponse = getCartDetails();
                                          });
                                        });
                                      }
                                    },
                            ),
                          ],
                        ),
                      ),
                      constructHorizontalLine(),
                    ],
                  )
                : ErrorPage(text: _response.error),
          );
        }
      },
    );
  }

  Widget constructHorizontalLine() {
    return Container(
      height: 2,
      color: Colors.black38,
    );
  }

  Future<AlertDialogResultEnum> displayDeleteDialog(BuildContext context) async {
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
              Text("Are you sure you want to delete?"),
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
}
