import 'package:flutter/material.dart';

import './../../apis/cart_apis.dart';
import './../../enums/generic_enums.dart';
import './../../helpers/custom_shared_preferences.dart';
import './../../helpers/extension_functions.dart';
import './../../helpers/static_functions.dart';
import './../../pages/shared_pages/empty_page.dart';
import './../../pages/shared_pages/error_page.dart';
import './../../pages/shared_pages/loading_page.dart';
import './../../resources/theme_designs.dart';
import './../../widgets/custom_alert_dialog.dart';
import './../../widgets/custom_app_bar.dart';
import './../../widgets/custom_progress_dialog.dart';
import './../../widgets/custom_sized_box.dart';

class CartCheckoutPage extends StatefulWidget {
  @override
  _CartCheckoutPageState createState() => _CartCheckoutPageState();
}

class _CartCheckoutPageState extends State<CartCheckoutPage> {
  Future<CartGetResponse> _cartGetResponse;
  int _userID;
  bool _isFirstLoad = true;
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
      future: getCartDetails(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting && _isFirstLoad) {
          return Scaffold(
            appBar: CustomAppBar(
              title: "Checkout",
              centerTitle: true,
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
              title: "Checkout",
              centerTitle: true,
            ),
            body: _response.error.isStringEmpty()
                ? Column(
                    children: <Widget>[
                      _response.cartVoucherDesignItems.isListEmpty()
                          ? EmptyPage()
                          : Container(
                              margin: EdgeInsets.all(10),
                              height: _deviceHeight * 0.75,
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
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(5, 0, 15, 0),
                                                child: Image.memory(
                                                  _response.cartVoucherDesignItems[index].voucherDesignImageBytes,
                                                  width: _imageHeight,
                                                  height: _imageHeight,
                                                ),
                                              ),
                                              Flexible(
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
                            Text("Total: ${_totalAmount.toCurrency()}", style: ThemeDesign.descriptionStyle),
                            Spacer(),
                            RaisedButton(
                              child: Text(
                                "Payment",
                                style: TextStyle(
                                  fontSize: ThemeDesign.buttonFontSize,
                                ),
                              ),
                              padding: EdgeInsets.all(10),
                              textColor: ThemeDesign.buttonTextPrimaryColor,
                              color: ThemeDesign.buttonPrimaryColor,
                              onPressed: _response.cartVoucherDesignItems.isListEmpty()
                                  ? null
                                  : () async {
                                      final _confirmCheckoutResult = await displayConfirmCheckoutDialog(context);

                                      if (_confirmCheckoutResult == AlertDialogResultEnum.success) {
                                        CustomProgressDialog.show(context);
                                        final int _userID =
                                            (await CustomSharedPreferences.getValue(StorageEnum.userID)).toInt();
                                        final _cartPaymentRequest = CartPaymentRequest(_userID);
                                        final _cartPaymentResponse = await CartApis.paymentApi(_cartPaymentRequest);
                                        CustomProgressDialog.hide(context);

                                        if (_cartPaymentResponse != "1") {
                                          CustomAlertDialog.showError(context, "Payment failed.");
                                        } else {
                                          await CustomAlertDialog.showSuccess(context, "Payment succeed.");

                                          Navigator.of(context).pop();
                                        }
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

  Future<AlertDialogResultEnum> displayConfirmCheckoutDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Confirm Payment',
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("Click OK to start payment process."),
              CustomSizedBox(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
