import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import './../../widgets/custom_alert_dialog.dart';
import './../../widgets/custom_progress_dialog.dart';
import './../../resources/theme_designs.dart';
import './../../widgets/custom_sized_box.dart';
import './../../widgets/custom_app_bar.dart';
import './../../apis/account_apis.dart';
import './../../helpers//extension_functions.dart';

class AccountUpdateProfilePicturePage extends StatefulWidget {
  final UserDetailsResponse userDetails;
  final String defaultGenderImage;
  final double pictureWidth;
  final double pictureHeight;

  AccountUpdateProfilePicturePage({
    Key key,
    @required this.userDetails,
    @required this.defaultGenderImage,
    @required this.pictureWidth,
    @required this.pictureHeight,
  }) : super(key: key);

  @override
  _AccountUpdateProfilePicturePageState createState() => _AccountUpdateProfilePicturePageState();
}

class _AccountUpdateProfilePicturePageState extends State<AccountUpdateProfilePicturePage> {
  File _selectedImage;
  bool _isSaveButtonEnabled = false;
  final int _maxImageSize = 62356;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Update Profile Photo",
      ),
      body: Container(
        padding: ThemeDesign.containerPaddingAll,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _getImage(),
              CustomSizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  GestureDetector(
                    onTap: () => _selectImageFromImagePicker(ImageSource.gallery),
                    child: Column(
                      children: <Widget>[
                        Icon(
                          Icons.add_photo_alternate,
                          color: ThemeDesign.appPrimaryColor900,
                          size: 128,
                        ),
                        CustomSizedBox(height: 5),
                        Text(
                          "Gallery",
                          style: ThemeDesign.descriptionStyle,
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _selectImageFromImagePicker(ImageSource.camera),
                    child: Column(
                      children: <Widget>[
                        Icon(
                          Icons.camera_alt,
                          color: ThemeDesign.appPrimaryColor900,
                          size: 128,
                        ),
                        CustomSizedBox(height: 5),
                        Text(
                          "Camera",
                          style: ThemeDesign.descriptionStyle,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              CustomSizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      child: Text(
                        "Save",
                        style: TextStyle(
                          fontSize: ThemeDesign.buttonFontSize,
                        ),
                      ),
                      padding: EdgeInsets.all(20),
                      textColor: ThemeDesign.buttonTextPrimaryColor,
                      color: ThemeDesign.buttonPrimaryColor,
                      onPressed: _isSaveButtonEnabled
                          ? () async {
                              if (_selectedImage == null) {
                                await CustomAlertDialog.showError(context, "No image is selected.");
                                return;
                              }

                              var _selectedImageBase64 = base64Encode(_selectedImage.readAsBytesSync());
                              var _pictureDetails = UpdateProfilePictureItem("image/jpeg", _selectedImageBase64);
                              if (_selectedImageBase64.length > _maxImageSize) {
                                await CustomAlertDialog.showError(context, "Image selected's size is too large.");
                                return;
                              }

                              CustomProgressDialog.show(context);
                              var _updateProfilePictureRequest =
                                  UpdateProfilePictureRequest(widget.userDetails.userID, _pictureDetails);
                              var _updateProfilePictureResponse =
                                  await AccountApis.updateProfilePictureApi(_updateProfilePictureRequest);
                              CustomProgressDialog.hide(context);

                              if (_updateProfilePictureResponse.error.isStringEmpty()) {
                                await CustomAlertDialog.showError(context, "Photo uploaded successfully.");

                                Navigator.of(context).pop();
                              } else {
                                CustomAlertDialog.showError(context, _updateProfilePictureResponse.error);
                              }
                            }
                          : null,
                    ),
                  ),
                  Container(width: 5),
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
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _selectImageFromImagePicker(ImageSource source) async {
    var image = await ImagePicker.pickImage(
      source: source,
      imageQuality: 50,
    );

    setState(() {
      _selectedImage = image;
      _isSaveButtonEnabled = true;
    });
  }

  _getImage() {
    if (_selectedImage == null) {
      if (widget.userDetails.profileImageBase64.isStringEmpty()) {
        return ClipOval(
          child: Image.asset(
            widget.defaultGenderImage,
            width: widget.pictureWidth,
            height: widget.pictureHeight,
            fit: BoxFit.cover,
          ),
        );
      } else {
        return ClipOval(
          child: Image.memory(
            widget.userDetails.profileImageBase64.toImage(),
            width: widget.pictureWidth,
            height: widget.pictureHeight,
            fit: BoxFit.cover,
          ),
        );
      }
    }

    return ClipOval(
      child: Image.file(
        _selectedImage,
        width: widget.pictureWidth,
        height: widget.pictureHeight,
        fit: BoxFit.cover,
      ),
    );
  }
}
