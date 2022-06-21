import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:email_validator/email_validator.dart';

import './../../apis/account_apis.dart';
import './../../resources/info_texts.dart';
import './../../widgets/custom_progress_dialog.dart';
import './../../apis/generic_apis.dart';
import './../../enums/generic_enums.dart';
import './../../helpers/custom_drop_down_button_listings.dart';
import './../../resources/theme_designs.dart';
import './../../widgets/custom_alert_dialog.dart';
import './../../widgets/custom_form_label.dart';
import './../../widgets/custom_sized_box.dart';
import './../../helpers/extension_functions.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  List<ListingItem> _genderListing;
  List<ListingItem> _stateListing;
  List<ListingItem> _countryListing;
  final TextEditingController _passwordController = new TextEditingController();
  final TextEditingController _confirmPasswordController = new TextEditingController();

  bool _enableObscureText = true;
  DateTime _selectedDateOfBirth = DateTime.now();
  String _email;
  String _password;
  String _name;
  String _mobileNo;
  String _gender;
  String _idNo;
  int _countryID;
  int _stateID;
  String _address1;
  String _address2;
  String _address3;
  String _postcode;
  String _townCity;

  @override
  void initState() {
    super.initState();
    CustomDropDownButtonListing.gender().then((result) {
      setState(() {
        _genderListing = result;
      });
    });

    CustomDropDownButtonListing.country().then((result) {
      setState(() {
        _countryListing = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registration"),
      ),
      body: SingleChildScrollView(
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
                      "Email",
                      showAsterisk: true,
                    ),
                    TextFormField(
                      decoration: _inputDecoration("Enter your email address"),
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
                  ],
                ),
              ),
              Container(
                padding: ThemeDesign.containerPaddingTopBottom,
                child: Column(
                  children: <Widget>[
                    CustomFormLabel(
                      "Password",
                      showAsterisk: true,
                    ),
                    TextFormField(
                      decoration: _inputDecoration("Enter your password", true),
                      onSaved: (value) => _password = value,
                      obscureText: _enableObscureText,
                      controller: _passwordController,
                      validator: (value) {
                        if (value.isStringEmpty()) {
                          return "Invalid password";
                        } else if (!_confirmPasswordController.text.isStringEmpty() &&
                            _confirmPasswordController.text != value) {
                          return "Password not matched";
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
                      "Confirm Password",
                      showAsterisk: true,
                    ),
                    TextFormField(
                      decoration: _inputDecoration("Enter your password again", true),
                      obscureText: _enableObscureText,
                      controller: _confirmPasswordController,
                      validator: (value) {
                        if (value.isStringEmpty()) {
                          return "Invalid confirm password";
                        } else if (!_passwordController.text.isStringEmpty() && _passwordController.text != value) {
                          return "Confirm Password not matched";
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
                      "Name",
                      showAsterisk: true,
                    ),
                    TextFormField(
                      decoration: _inputDecoration("Enter your name"),
                      onSaved: (value) => _name = value,
                      validator: (value) {
                        if (value.isStringEmpty()) {
                          return "Invalid name";
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
                      "Mobile No.",
                      showAsterisk: true,
                    ),
                    TextFormField(
                      decoration: _inputDecoration("Enter your mobile no."),
                      onSaved: (value) => _mobileNo = value,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        WhitelistingTextInputFormatter.digitsOnly,
                      ],
                      validator: (value) {
                        if (value.isStringEmpty()) {
                          return "Invalid mobile no.";
                        } else {
                          return null;
                        }
                      },
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: ThemeDesign.containerPaddingTopBottom,
                child: Column(
                  children: <Widget>[
                    CustomFormLabel(
                      "Gender",
                    ),
                    _genderDropDownButton(),
                  ],
                ),
              ),
              Container(
                padding: ThemeDesign.containerPaddingTopBottom,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CustomFormLabel(
                      "Date of Birth",
                    ),
                    CustomSizedBox(),
                    GestureDetector(
                      onTap: () => _selectDate(context),
                      child: Text(
                        "${_selectedDateOfBirth.convertDateToString()}",
                        style: ThemeDesign.titleStyle,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: ThemeDesign.containerPaddingTopBottom,
                child: Column(
                  children: <Widget>[
                    CustomFormLabel(
                      "ID No.",
                      showAsterisk: true,
                    ),
                    TextFormField(
                      decoration: _inputDecoration("Enter your ID No."),
                      onSaved: (value) => _idNo = value,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        WhitelistingTextInputFormatter.digitsOnly,
                      ],
                      validator: (value) {
                        if (value.isStringEmpty()) {
                          return "Invalid ID no..";
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
                      "Country",
                    ),
                    _countryDropDownButton(),
                  ],
                ),
              ),
              Container(
                padding: ThemeDesign.containerPaddingTopBottom,
                child: Column(
                  children: <Widget>[
                    CustomFormLabel(
                      "State",
                    ),
                    _stateDropDownButton(),
                  ],
                ),
              ),
              Container(
                padding: ThemeDesign.containerPaddingTopBottom,
                child: Column(
                  children: <Widget>[
                    CustomFormLabel(
                      "Address Line 1",
                      showAsterisk: true,
                    ),
                    TextFormField(
                      decoration: _inputDecoration("Enter your address"),
                      onSaved: (value) => _address1 = value,
                      validator: (value) {
                        if (value.isStringEmpty()) {
                          return "Invalid address.";
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
                      "Address Line 2",
                    ),
                    TextFormField(
                      decoration: _inputDecoration(""),
                      onSaved: (value) => _address2 = value,
                    ),
                  ],
                ),
              ),
              Container(
                padding: ThemeDesign.containerPaddingTopBottom,
                child: Column(
                  children: <Widget>[
                    CustomFormLabel("Address Line 3"),
                    TextFormField(
                      decoration: _inputDecoration(""),
                      onSaved: (value) => _address3 = value,
                    ),
                  ],
                ),
              ),
              Container(
                padding: ThemeDesign.containerPaddingTopBottom,
                child: Column(
                  children: <Widget>[
                    CustomFormLabel(
                      "Postcode",
                      showAsterisk: true,
                    ),
                    TextFormField(
                      decoration: _inputDecoration("Enter your postcode"),
                      onSaved: (value) => _postcode = value,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        WhitelistingTextInputFormatter.digitsOnly,
                      ],
                      validator: (value) {
                        if (value.isStringEmpty()) {
                          return "Invalid postcode";
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
                      "Town/City",
                      showAsterisk: true,
                    ),
                    TextFormField(
                      decoration: _inputDecoration("Enter your town/city"),
                      onSaved: (value) => _townCity = value,
                      validator: (value) {
                        if (value.isStringEmpty()) {
                          return "Invalid town/city";
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
                      var _birthdayDate = DateFormat("yyyy-MM-dd").format(_selectedDateOfBirth);
                      var registrationRequest = RegistrationRequest(
                          _email,
                          _password,
                          _name,
                          _email,
                          _mobileNo,
                          _birthdayDate,
                          _gender,
                          _idNo,
                          _address1,
                          _address2,
                          _address3,
                          _postcode,
                          _townCity,
                          _stateID);
                      var registrationResponse = await AccountApis.registrationApi(registrationRequest);
                      CustomProgressDialog.hide(context);

                      if (registrationResponse.error.isStringEmpty()) {
                        var result = await CustomAlertDialog.showSuccess(context,
                            "Verification Code sent to your email. Kindly login for the first time and enter the Verification Code when prompted.");

                        if (result == AlertDialogResultEnum.success) {
                          setState(() {
                            _autoValidate = false;
                          });

                          Navigator.of(context).pop();
                        }
                      } else {
                        CustomAlertDialog.showError(context, registrationResponse.error);
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

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateOfBirth,
      firstDate: DateTime(DateTime.now().year - 99),
      lastDate: DateTime(DateTime.now().year, 12, 31),
    );
    if (picked != null && picked != _selectedDateOfBirth)
      setState(() {
        _selectedDateOfBirth = picked;
      });
  }

  Widget _genderDropDownButton() {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      iconSize: ThemeDesign.dropDownButtonIconSize,
      value: _gender,
      hint: Text(InfoText.dropDownButtonDefaultText),
      validator: (value) {
        if (value == null) {
          return 'Invalid gender';
        }

        return null;
      },
      items: _genderListing.isListEmpty()
          ? null
          : _genderListing.map((ListingItem item) {
              return DropdownMenuItem<String>(
                value: item.stringValue,
                child: Text(item.text),
              );
            }).toList(),
      onChanged: (value) {
        setState(() {
          _gender = _genderListing.firstWhere((a) => a.stringValue == value).stringValue;
        });
      },
    );
  }

  Widget _stateDropDownButton() {
    return DropdownButtonFormField<int>(
      hint: Text(InfoText.dropDownButtonDefaultText),
      isExpanded: true,
      iconSize: ThemeDesign.dropDownButtonIconSize,
      value: _stateID,
      validator: (value) {
        if (value == null) {
          return 'Invalid state';
        }

        return null;
      },
      items: _stateListing.isListEmpty()
          ? null
          : _stateListing.map((ListingItem item) {
              return DropdownMenuItem<int>(
                value: item.value,
                child: Text(item.text),
              );
            }).toList(),
      onChanged: (value) {
        setState(() {
          _stateID = _stateListing.firstWhere((a) => a.value == value).value;
        });
      },
    );
  }

  Widget _countryDropDownButton() {
    return DropdownButtonFormField<int>(
      hint: Text(InfoText.dropDownButtonDefaultText),
      isExpanded: true,
      iconSize: ThemeDesign.dropDownButtonIconSize,
      value: _countryID,
      validator: (value) {
        if (value == null) {
          return 'Invalid country';
        }

        return null;
      },
      items: _countryListing.isListEmpty()
          ? null
          : _countryListing.map((ListingItem item) {
              return DropdownMenuItem<int>(
                value: item.value,
                child: Text(item.text),
              );
            }).toList(),
      onChanged: (value) async {
        var _stateListingRequest = StateListingRequest(value.toString());
        var _stateListingResponse = await GenericApis.stateListingApi(_stateListingRequest);

        setState(() {
          _stateListing = _stateListingResponse.items;
          _countryID = _countryListing.firstWhere((a) => a.value == value).value;
        });
      },
    );
  }

  void _toggleObscureText() {
    setState(() {
      _enableObscureText = !_enableObscureText;
    });
  }
}
