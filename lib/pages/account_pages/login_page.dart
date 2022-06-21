import 'dart:async';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:provider/provider.dart';

import './../../models/account_models.dart';
import './../../widgets/custom_alert_dialog.dart';
import './../../apis/account_apis.dart';
import './../../widgets/custom_form_label.dart';
import './../../enums/generic_enums.dart';
import './../../helpers/custom_shared_preferences.dart';
import './../../helpers/static_functions.dart';
import './../../pages/account_pages/forgot_password_page.dart';
import './../../pages/account_pages/registration_page.dart';
import './../../pages/generic_pages/bottom_navigation_bar_page.dart';
import './../../resources/theme_designs.dart';
import './../../widgets/custom_progress_dialog.dart';
import './../../widgets/custom_sized_box.dart';
import './../../widgets/custom_text_field_decoration.dart';
import './../../helpers/extension_functions.dart';
import './../../widgets/custom_app_bar.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _password;
  String _email;
  TextEditingController _verificationCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        hideAppBar: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: ThemeDesign.containerPaddingLeftRight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "assets/pictures/quill.png",
                width: StaticFunctions.getDeviceWidth(context) * 0.6,
                height: StaticFunctions.getDeviceHeight(context) * 0.35,
              ),
              Container(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      CustomFormLabel("Email"),
                      TextFormField(
                        decoration: customTextFieldDecoration(
                            "Enter you email address"),
                        onSaved: (value) => _email = value,
                        initialValue: "abc@abc.com",
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          var isValidEmail = EmailValidator.validate(value);

                          if (!isValidEmail) {
                            return "Invalid email address";
                          } else {
                            return null;
                          }
                        },
                      ),
                      CustomSizedBox(),
                      CustomFormLabel("Password"),
                      TextFormField(
                        decoration:
                            customTextFieldDecoration("'Enter you password'"),
                        onSaved: (value) => _password = value,
                        initialValue: "abc123",
                        obscureText: true,
                        validator: (value) {
                          if (value.isStringEmpty()) {
                            return "Invalid password";
                          } else {
                            return null;
                          }
                        },
                      ),
                      CustomSizedBox(),
                      SizedBox(
                        width: double.infinity,
                        child: RaisedButton(
                          child: Text(
                            "Login",
                            style: TextStyle(
                              fontSize: ThemeDesign.buttonFontSize,
                            ),
                          ),
                          padding: EdgeInsets.all(20),
                          textColor: ThemeDesign.buttonTextPrimaryColor,
                          color: ThemeDesign.buttonPrimaryColor,
                          onPressed: () async {
                            _verificationCodeController.clear();
                            final form = _formKey.currentState;
                            form.save();

                            if (form.validate()) {
                              var _loginResponse = await _callLoginApi(
                                  context,
                                  _email,
                                  _password,
                                  _verificationCodeController.text);

                              if (!_loginResponse.isValid) {
                                CustomAlertDialog.showError(
                                    context, _loginResponse.error);
                                return;
                              }

                              if (_loginResponse.isFirstLogin) {
                                var popupButtonClick =
                                    await _displayDialog(context);

                                if (popupButtonClick == "confirm") {
                                  var _loginResponse = await _callLoginApi(
                                      context,
                                      _email,
                                      _password,
                                      _verificationCodeController.text);

                                  if (!_loginResponse.isValid) {
                                    CustomAlertDialog.showError(
                                        context, _loginResponse.error);
                                    return;
                                  }

                                  if (!_loginResponse.isFirstLogin) {
                                    goToHomePage(
                                        context, _loginResponse.userID);
                                  }
                                  goToHomePage(context, _loginResponse.userID);
                                }
                              } else {
                                goToHomePage(context, _loginResponse.userID);
                              }
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
              CustomSizedBox(),
              _flatButton("Forgot Your Password?", ForgotPasswordPage()),
              _flatButton("First Time Login", RegistrationPage()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _flatButton(String text, Widget page) {
    return FlatButton(
      padding: EdgeInsets.all(0),
      child: Text(
        text,
        style: TextStyle(fontSize: 16),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      textColor: Colors.grey,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
    );
  }

  Future<dynamic> _displayDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Enter Verification Code',
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _verificationCodeController,
                decoration: customTextFieldDecoration(""),
              ),
              CustomSizedBox(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  OutlineButton(
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        fontSize: ThemeDesign.buttonFontSize,
                      ),
                    ),
                    padding: EdgeInsets.all(20),
                    textColor: ThemeDesign.buttonTextSecondaryColor,
                    color: ThemeDesign.buttonSecondaryColor,
                    highlightedBorderColor:
                        ThemeDesign.buttonTextSecondaryColor,
                    borderSide: BorderSide(
                      color: ThemeDesign.buttonTextSecondaryColor,
                      width: 2,
                    ),
                    onPressed: () {
                      Navigator.pop(context, 'cancel');
                    },
                  ),
                  RaisedButton(
                    child: Text(
                      "Submit",
                      style: TextStyle(
                        fontSize: ThemeDesign.buttonFontSize,
                      ),
                    ),
                    padding: EdgeInsets.all(20),
                    textColor: ThemeDesign.buttonTextPrimaryColor,
                    color: ThemeDesign.buttonPrimaryColor,
                    onPressed: () {
                      Navigator.pop(context, 'confirm');
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<ValidateUserResponse> _callLoginApi(BuildContext context, String email,
      String password, String verificationCode) async {
    CustomProgressDialog.show(context);

    var request = ValidateUserRequest(email, password, verificationCode);
    var response = await AccountApis.validateUserApi(request);

    CustomProgressDialog.hide(context);

    return response;
  }

  void goToHomePage(BuildContext context, int userID) {
    CustomSharedPreferences.setValue(StorageEnum.email, _email);
    CustomSharedPreferences.setValue(StorageEnum.userID, userID.toString());

    Provider(
      create: (_) => UserDetailsModel(userID, _email),
    );

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => BottomNavigationBarPage()),
      (Route<dynamic> route) => false,
    );
  }
}
