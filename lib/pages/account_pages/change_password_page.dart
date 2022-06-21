import 'package:flutter/material.dart';

import './../../enums/generic_enums.dart';
import './../../helpers/custom_shared_preferences.dart';
import './../../resources/theme_designs.dart';
import './../../widgets/custom_alert_dialog.dart';
import './../../widgets/custom_form_label.dart';
import './../../widgets/custom_progress_dialog.dart';
import './../../apis/account_apis.dart';
import './../../widgets/custom_app_bar.dart';
import './../../helpers/extension_functions.dart';

class ChangePasswordPage extends StatefulWidget {
  final UserDetailsResponse userDetails;

  ChangePasswordPage({Key key, @required this.userDetails}) : super(key: key);

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  final TextEditingController _newPasswordController = new TextEditingController();
  final TextEditingController _confirmNewPasswordController = new TextEditingController();
  bool _enableObscureText = true;
  String _currentPassword;
  String _newPassword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Change Password",
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: ThemeDesign.containerPaddingAll,
          child: Form(
            key: _formKey,
            autovalidate: _autoValidate,
            child: Column(
              children: <Widget>[
                Container(
                  padding: ThemeDesign.containerPaddingTopBottom,
                  child: Column(
                    children: <Widget>[
                      CustomFormLabel(
                        "Current Password",
                        showAsterisk: true,
                      ),
                      TextFormField(
                        decoration: _inputDecoration("Enter your current password", true),
                        onSaved: (value) => _currentPassword = value,
                        obscureText: _enableObscureText,
                        validator: (value) {
                          if (value.isStringEmpty()) {
                            return "Invalid current password";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: ThemeDesign.containerPaddingTopBottom,
                  child: Column(
                    children: <Widget>[
                      CustomFormLabel(
                        "New Password",
                        showAsterisk: true,
                      ),
                      TextFormField(
                        decoration: _inputDecoration("Enter your new password", true),
                        onSaved: (value) => _newPassword = value,
                        obscureText: _enableObscureText,
                        controller: _newPasswordController,
                        validator: (value) {
                          if (value.isStringEmpty()) {
                            return "Invalid new password";
                          } else if (!_confirmNewPasswordController.text.isStringEmpty() &&
                              _confirmNewPasswordController.text != value) {
                            return "New Password not matched";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: ThemeDesign.containerPaddingTopBottom,
                  child: Column(
                    children: <Widget>[
                      CustomFormLabel(
                        "Confirm New Password",
                        showAsterisk: true,
                      ),
                      TextFormField(
                        decoration: _inputDecoration("Enter your new password again", true),
                        obscureText: _enableObscureText,
                        controller: _confirmNewPasswordController,
                        validator: (value) {
                          if (value.isStringEmpty()) {
                            return "Invalid Confirm New Password";
                          } else if (!_newPasswordController.text.isStringEmpty() &&
                              _newPasswordController.text != value) {
                            return "Confirm New Password not matched";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    child: Text(
                      "Submit",
                      style: TextStyle(
                        fontSize: ThemeDesign.buttonFontSize,
                      ),
                    ),
                    padding: EdgeInsets.all(20),
                    textColor: ThemeDesign.buttonTextPrimaryColor,
                    color: ThemeDesign.buttonPrimaryColor,
                    onPressed: () async {
                      final form = _formKey.currentState;
                      form.save();

                      if (form.validate()) {
                        CustomProgressDialog.show(context);
                        var _email = await CustomSharedPreferences.getValue(StorageEnum.email);
                        var _changePasswordItem = ChangePasswordItem(_email, _currentPassword, _newPassword);
                        var _changePasswordRequest = ChangePasswordRequest(_changePasswordItem);
                        var _changePasswordResponse = await AccountApis.changePasswordApi(_changePasswordRequest);
                        CustomProgressDialog.hide(context);

                        if (_changePasswordResponse.error.isStringEmpty()) {
                          var result = await CustomAlertDialog.showSuccess(context, "Password updated successfully.");

                          if (result == AlertDialogResultEnum.success) {
                            setState(() {
                              _autoValidate = false;
                            });

                            Navigator.of(context).pop();
                          }
                        } else {
                          CustomAlertDialog.showError(context, _changePasswordResponse.error);
                        }
                      } else {
                        if (!_autoValidate) {
                          setState(() {
                            _autoValidate = true;
                          });
                        }
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hintText, [bool showIcon = false]) {
    return InputDecoration(
      hintText: hintText,
      suffixIcon: showIcon
          ? IconButton(
              icon: Icon(
                _enableObscureText ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: () => _toggleObscureText(),
            )
          : null,
    );
  }

  void _toggleObscureText() {
    setState(() {
      _enableObscureText = !_enableObscureText;
    });
  }
}
