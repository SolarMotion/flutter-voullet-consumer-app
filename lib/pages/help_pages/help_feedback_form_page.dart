import 'dart:convert';
import 'dart:io';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import './../../apis/help_apis.dart';
import './../../enums/generic_enums.dart';
import './../../helpers/static_functions.dart';
import './../../resources/theme_designs.dart';
import './../../widgets/custom_alert_dialog.dart';
import './../../widgets/custom_form_label.dart';
import './../../widgets/custom_progress_dialog.dart';
import './../../widgets/custom_sized_box.dart';
import './../../widgets/custom_text_field_decoration.dart';
import './../../helpers/extension_functions.dart';
import './../../widgets/custom_app_bar.dart';

class HelpFeedbackFormPage extends StatefulWidget {
  @override
  _HelpFeedbackFormPageState createState() => _HelpFeedbackFormPageState();
}

class _HelpFeedbackFormPageState extends State<HelpFeedbackFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  int _radioValue = 0;
  String _radioText = describeEnum(FeedbackFormTypeEnum.issue).capitalize();
  File _selectedImage;

  String _name;
  String _email;
  String _contactNo;
  String _subject;
  String _description;
  final TextEditingController _nameController = new TextEditingController();
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _contactNoController = new TextEditingController();
  final TextEditingController _subjectController = new TextEditingController();
  final TextEditingController _descriptionController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Feedback Form",
      ),
      body: SingleChildScrollView(
        padding: ThemeDesign.containerPaddingAll,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Send us some feedback!",
              textAlign: TextAlign.start,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
            CustomSizedBox(),
            Text(
              "DO you have any suggestion or encounter somee issues? Please let us know about it.",
              style: ThemeDesign.descriptionStyle,
            ),
            CustomSizedBox(
              height: 30,
            ),
            Form(
              key: _formKey,
              autovalidate: _autoValidate,
              child: Column(
                children: <Widget>[
                  CustomFormLabel(
                    "Name",
                    showAsterisk: true,
                  ),
                  TextFormField(
                    decoration: customTextFieldDecoration(""),
                    onSaved: (value) => _name = value,
                    controller: _nameController,
                    validator: (value) {
                      if (value.isStringEmpty()) {
                        return "Name is required";
                      } else {
                        return null;
                      }
                    },
                  ),
                  CustomSizedBox(),
                  CustomFormLabel(
                    "Email",
                    showAsterisk: true,
                  ),
                  TextFormField(
                    decoration: customTextFieldDecoration(""),
                    onSaved: (value) => _email = value,
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
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
                  CustomFormLabel(
                    "Contact No.",
                    showAsterisk: true,
                  ),
                  TextFormField(
                    decoration: customTextFieldDecoration(""),
                    onSaved: (value) => _contactNo = value,
                    controller: _contactNoController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly,
                    ],
                    validator: (value) {
                      if (value.isStringEmpty()) {
                        return "Contact No. is required";
                      } else {
                        return null;
                      }
                    },
                  ),
                  CustomSizedBox(),
                  CustomFormLabel(
                    "Subject",
                    showAsterisk: true,
                  ),
                  TextFormField(
                    decoration: customTextFieldDecoration(""),
                    onSaved: (value) => _subject = value,
                    controller: _subjectController,
                    validator: (value) {
                      if (value.isStringEmpty()) {
                        return "Subject is required";
                      } else {
                        return null;
                      }
                    },
                  ),
                  CustomSizedBox(),
                  CustomFormLabel(
                    "Description",
                    showAsterisk: true,
                  ),
                  TextFormField(
                    decoration: customTextFieldDecoration("Describe your issue or comment"),
                    onSaved: (value) => _description = value,
                    controller: _descriptionController,
                    validator: (value) {
                      if (value.isStringEmpty()) {
                        return "Description is required";
                      } else {
                        return null;
                      }
                    },
                    maxLines: 5,
                  ),
                  CustomSizedBox(),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Radio(
                        value: 0,
                        groupValue: _radioValue,
                        onChanged: _handleRadioValueChange,
                      ),
                      new Text('Issue'),
                      SizedBox(width: 30),
                      new Radio(
                        value: 1,
                        groupValue: _radioValue,
                        onChanged: _handleRadioValueChange,
                      ),
                      new Text('Comment'),
                      SizedBox(width: 30),
                      new Radio(
                        value: 2,
                        groupValue: _radioValue,
                        onChanged: _handleRadioValueChange,
                      ),
                      new Text('Other'),
                      SizedBox(width: 30),
                    ],
                  ),
                  CustomSizedBox(),
                  GestureDetector(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: <Widget>[
                              Text(
                                "Upload Image",
                                style: ThemeDesign.descriptionStyle,
                              ),
                              Spacer(),
                              Icon(Icons.camera_alt),
                            ],
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: _selectedImage == null
                              ? Text("No image is selected.",
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                  ),
                                  textAlign: TextAlign.center)
                              : Stack(
                                  alignment: Alignment.bottomRight,
                                  children: <Widget>[
                                    Image.file(
                                      _selectedImage,
                                      width: StaticFunctions.getDeviceWidth(context) * 0.9,
                                      height: StaticFunctions.getDeviceHeight(context) * 0.35,
                                      fit: BoxFit.cover,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(0),
                                      child: ClipOval(
                                        child: Container(
                                          color: Colors.red[800],
                                          child: IconButton(
                                            onPressed: () async {
                                              var _deleteConfirmationResult = await _displayDeleteDialog(context);

                                              if (_deleteConfirmationResult == "yes") {
                                                setState(() {
                                                  _selectedImage = null;
                                                });
                                              }
                                            },
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: Colors.black,
                              ),
                              right: BorderSide(
                                color: Colors.black,
                              ),
                              bottom: BorderSide(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      _modalBottomSheet(context);

                      // final act = CupertinoActionSheet(
                      //   title: Text('Photo from'),
                      //   actions: <Widget>[
                      //     CupertinoActionSheetAction(
                      //       child: Text('Camera'),
                      //       onPressed: () {
                      //         _selectImageFromImagePicker(ImageSource.camera);
                      //       },
                      //     ),
                      //     CupertinoActionSheetAction(
                      //       child: Text('Photo Album'),
                      //       onPressed: () {
                      //         _selectImageFromImagePicker(ImageSource.gallery);
                      //       },
                      //     )
                      //   ],
                      //   cancelButton: CupertinoActionSheetAction(
                      //     isDefaultAction: false,
                      //     child: Text('Cancel'),
                      //     onPressed: () {
                      //       Navigator.pop(context);
                      //     },
                      //   ),
                      // );
                      // showCupertinoModalPopup(context: context, builder: (BuildContext context) => act);
                    },
                  ),
                ],
              ),
            ),
            CustomSizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: OutlineButton(
                    child: Text(
                      "Reset",
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
                      _formKey.currentState.reset();
                      _nameController.clear();
                      _emailController.clear();
                      _contactNoController.clear();
                      _subjectController.clear();
                      _descriptionController.clear();
                      setState(() {
                        _radioValue = 0;
                        _selectedImage = null;
                      });
                    },
                  ),
                ),
                Container(width: 5),
                Expanded(
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
                        var _selectedImageBase64 =
                            _selectedImage == null ? null : base64Encode(_selectedImage.readAsBytesSync());
                        var _imageList = _selectedImageBase64 == null ? <String>[] : [_selectedImageBase64];
                        var _feedbackFormRequest = FeedbackFormRequest(
                            _name, _email, _contactNo, _subject, _description, _radioText, _imageList);

                        var _feedbackFormResponse = await HelpApis.feedbackFormApi(_feedbackFormRequest);
                        CustomProgressDialog.hide(context);

                        if (_feedbackFormResponse.error.isStringEmpty()) {
                          await CustomAlertDialog.showSuccess(context,
                              "Thank you for your feedback. We will get back to you in ${_feedbackFormResponse.waitingDuration} working days");

                          Navigator.of(context).pop();
                        } else {
                          CustomAlertDialog.showError(context, _feedbackFormResponse.error);
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _modalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            color: ThemeDesign.appPrimaryColor900,
            child: Wrap(
              children: <Widget>[
                Container(
                  child: ListTile(
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Photo From",
                          style: TextStyle(
                            fontSize: ThemeDesign.titleFontSize,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                  ),
                  title: Text(
                    'Camera',
                    style: TextStyle(
                      fontSize: ThemeDesign.descriptionFontSize,
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    _selectImageFromImagePicker(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.add_photo_alternate,
                    color: Colors.white,
                  ),
                  title: Text(
                    'Photo Album',
                    style: TextStyle(
                      fontSize: ThemeDesign.descriptionFontSize,
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    _selectImageFromImagePicker(ImageSource.gallery);
                  },
                ),
              ],
            ),
          );
        });
  }

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;

      switch (_radioValue) {
        case 0:
          _radioText = describeEnum(FeedbackFormTypeEnum.issue).capitalize();
          break;
        case 1:
          _radioText = describeEnum(FeedbackFormTypeEnum.comment).capitalize();
          break;
        case 2:
          _radioText = describeEnum(FeedbackFormTypeEnum.other).capitalize();
          break;
      }
    });
  }

  void _selectImageFromImagePicker(ImageSource source) async {
    var image = await ImagePicker.pickImage(
      source: source,
      imageQuality: 50,
    );

    if (image != null) {
      setState(() {
        _selectedImage = image;
      });

      Navigator.pop(context);
    }
  }

  Future<dynamic> _displayDeleteDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Delete Image',
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "Are you sure you want to delete this image?",
                style: ThemeDesign.descriptionStyle,
              ),
              CustomSizedBox(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Expanded(
                    child: OutlineButton(
                      child: Text(
                        "No",
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
                        Navigator.pop(context, 'no');
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: RaisedButton(
                      child: Text(
                        "Yes",
                        style: TextStyle(
                          fontSize: ThemeDesign.buttonFontSize,
                        ),
                      ),
                      padding: EdgeInsets.all(20),
                      textColor: ThemeDesign.buttonTextPrimaryColor,
                      color: ThemeDesign.buttonPrimaryColor,
                      onPressed: () {
                        Navigator.pop(context, 'yes');
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
