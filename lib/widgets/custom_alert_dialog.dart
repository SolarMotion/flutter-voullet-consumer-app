import 'package:flutter/material.dart';

import 'custom_sized_box.dart';
import './../resources/theme_designs.dart';
import './../enums/generic_enums.dart';
import './../helpers/extension_functions.dart';

class CustomAlertDialog {
  static Future<AlertDialogResultEnum> showSuccess(BuildContext context, String content,
      {String title = "Success", String closeButtonText = "OK"}) {
    try {
      return showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return WillPopScope(
              onWillPop: () {
                return Future.value(false);
              },
              child: AlertDialog(
                title: title.isStringEmpty()
                    ? Container()
                    : Text(
                        title,
                        textAlign: TextAlign.center,
                      ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      content,
                      style: ThemeDesign.descriptionStyle,
                      textAlign: TextAlign.center,
                    ),
                    CustomSizedBox(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                            child: Text(
                              closeButtonText,
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            );
          });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  static Future<AlertDialogResultEnum> showError(BuildContext context, String content,
      {String title = "Error", String closeButtonText = "OK"}) {
    try {
      return showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return WillPopScope(
              onWillPop: () {
                return Future.value(false);
              },
              child: AlertDialog(
                title: title.isStringEmpty()
                    ? Container()
                    : Text(
                        title,
                        textAlign: TextAlign.center,
                      ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      content,
                      style: ThemeDesign.descriptionStyle,
                      textAlign: TextAlign.center,
                    ),
                    CustomSizedBox(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                            child: Text(
                              closeButtonText,
                              style: TextStyle(
                                fontSize: ThemeDesign.buttonFontSize,
                              ),
                            ),
                            padding: EdgeInsets.all(20),
                            textColor: ThemeDesign.buttonTextPrimaryColor,
                            color: ThemeDesign.buttonPrimaryColor,
                            onPressed: () {
                              Navigator.pop(context, AlertDialogResultEnum.error);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            );
          });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
