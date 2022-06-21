import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

import './../../apis/account_apis.dart';
import './../../widgets/custom_alert_dialog.dart';
import './../../widgets/custom_progress_dialog.dart';
import './../../widgets/custom_form_label.dart';
import './../../helpers/static_functions.dart';
import './../../resources/theme_designs.dart';
import './../../widgets/custom_app_bar.dart';
import './../../widgets/custom_sized_box.dart';
import './../../widgets/custom_text_field_decoration.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = new TextEditingController();

  String _email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Forgot Password",
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: ThemeDesign.containerPaddingLeftRight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "assets/pictures/forgot_password.png",
                width: StaticFunctions.getDeviceWidth(context) * 0.6,
                height: StaticFunctions.getDeviceHeight(context) * 0.25,
              ),
              CustomSizedBox(),
              Text(
                "Please enter you registered email address to request a password reset.",
                style: ThemeDesign.descriptionStyle,
                textAlign: TextAlign.center,
              ),
              CustomSizedBox(height: 30),
              Container(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      CustomFormLabel(
                        "Email",
                        showAsterisk: true,
                      ),
                      TextFormField(
                        controller: _emailController,
                        autofocus: false,
                        decoration: customTextFieldDecoration("Enter you email address"),
                        onSaved: (value) => _email = value,
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
                      SizedBox(
                        width: double.infinity,
                        child: RaisedButton(
                          child: Text(
                            "Confirm",
                            style: TextStyle(
                              fontSize: ThemeDesign.buttonFontSize,
                            ),
                          ),
                          padding: EdgeInsets.all(ThemeDesign.buttonPadding),
                          textColor: ThemeDesign.buttonTextPrimaryColor,
                          color: ThemeDesign.buttonPrimaryColor,
                          onPressed: () async {
                            final form = _formKey.currentState;
                            form.save();

                            if (form.validate()) {
                              CustomProgressDialog.show(context);

                              var request = ForgotPasswordRequest(_email);
                              var response = await AccountApis.forgotPasswordApi(request);

                              CustomProgressDialog.hide(context);

                              if (response.isValid) {
                                await CustomAlertDialog.showSuccess(
                                    context, "Password reset successfully. Please check your mailbox.");

                                Navigator.of(context).pop();
                              } else {
                                CustomAlertDialog.showError(context, response.error);
                              }
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
