import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './../../apis/generic_apis.dart';
import './../../enums/generic_enums.dart';
import './../../helpers/custom_drop_down_button_listings.dart';
import './../../resources/theme_designs.dart';
import './../../widgets/custom_alert_dialog.dart';
import './../../widgets/custom_form_label.dart';
import './../../widgets/custom_progress_dialog.dart';
import './../../apis/account_apis.dart';
import './../../widgets/custom_app_bar.dart';
import './../../helpers/extension_functions.dart';
import './../../resources/info_texts.dart';
import './../../widgets/custom_sized_box.dart';
import './../../helpers/custom_shared_preferences.dart';

class AccountUpdateDetailsPage extends StatefulWidget {
  final UserDetailsResponse userDetails;

  AccountUpdateDetailsPage({Key key, @required this.userDetails}) : super(key: key);

  @override
  _AccountUpdateDetailsPageState createState() => _AccountUpdateDetailsPageState();
}

class _AccountUpdateDetailsPageState extends State<AccountUpdateDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  List<ListingItem> _genderListing;
  List<ListingItem> _stateListing;
  DateTime _selectedDateOfBirth;
  String _name;
  String _mobileNo;
  String _gender;
  String _idNo;
  int _stateID;
  String _address1;
  String _address2;
  String _address3;
  String _postcode;
  String _townCity;

  @override
  void initState() {
    super.initState();
    _selectedDateOfBirth = DateFormat("yyyy-MM-dd").parse(widget.userDetails.birthday);
    _gender = widget.userDetails.gender;
    _stateID = widget.userDetails.stateID;

    CustomDropDownButtonListing.gender().then((result) {
      setState(() {
        _genderListing = result;
      });
    });

    CustomDropDownButtonListing.country().then((result) {
      CustomDropDownButtonListing.state(result[0].value).then((result) {
        setState(() {
          _stateListing = result;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Update Account Details",
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
                      "Name",
                      showAsterisk: true,
                    ),
                    TextFormField(
                      decoration: _inputDecoration("Enter your name"),
                      onSaved: (value) => _name = value,
                      initialValue: widget.userDetails.name,
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
                      initialValue: widget.userDetails.mobileNo,
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
                      initialValue: widget.userDetails.idNo,
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
                      initialValue: widget.userDetails.address1,
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
                      initialValue: widget.userDetails.address2,
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
                      initialValue: widget.userDetails.address3,
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
                      initialValue: widget.userDetails.postcode,
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
                      initialValue: widget.userDetails.townCity,
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
                      var _updateUserDetailsItem = UpdateUserDetailsItem(_name, _idNo, _birthdayDate, _gender,
                          _mobileNo, _address1, _address2, _address3, _postcode, _townCity, _stateID);
                      var _userID = (await CustomSharedPreferences.getValue(StorageEnum.userID)).toInt();
                      var _updateUserDetailsRequest = UpdateUserDetailsRequest(_userID, _updateUserDetailsItem);
                      var _updateUserDetailsResponse =
                          await AccountApis.updateUserDetailsApi(_updateUserDetailsRequest);
                      CustomProgressDialog.hide(context);

                      if (_updateUserDetailsResponse.error.isStringEmpty()) {
                        var result = await CustomAlertDialog.showSuccess(context, "Profile updated successfully.");

                        if (result == AlertDialogResultEnum.success) {
                          setState(() {
                            _autoValidate = false;
                          });

                          Navigator.of(context).pop();
                        }
                      } else {
                        CustomAlertDialog.showError(context, _updateUserDetailsResponse.error);
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

  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
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
      value:_stateID,
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
}
