import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';

import './../../apis/account_apis.dart';
import './../../enums/generic_enums.dart';
import './../../helpers/custom_shared_preferences.dart';
import './../../helpers/extension_functions.dart';
import './../../helpers/static_functions.dart';
import './../../pages/account_pages/account_update_profile_picture_page.dart';
import './../../pages/account_pages/accout_update_details_page.dart';
import './../../pages/account_pages/change_password_page.dart';
import './../../pages/shared_pages/loading_page.dart';
import './../../resources/theme_designs.dart';
import './../../widgets/custom_app_bar.dart';
import './../../widgets/custom_sized_box.dart';

class AccountDetailsPage extends StatefulWidget {
  @override
  _AccountDetailsPageState createState() => _AccountDetailsPageState();
}

class _AccountDetailsPageState extends State<AccountDetailsPage> {
  final GlobalKey<FabCircularMenuState> _fabKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getUserDetails(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          return snapshot.data;
        } else {
          return Scaffold(
            appBar: CustomAppBar(
              title: "Personal Information",
            ),
            body: LoadingPage(),
          );
        }
      },
    );
  }

  Future<Widget> _getUserDetails() async {
    var _userID = (await CustomSharedPreferences.getValue(StorageEnum.userID)).toInt();
    var _userDetailsRequest = UserDetailsRequest(_userID);
    var _userDetails = await AccountApis.userDetailsApi(_userDetailsRequest);
    var _userImage = _userDetails.profileImageBase64.toImage();
    var _genderImage = _userDetails.gender.compareTo(GenderEnum.male.toString()) == 1
        ? "assets/pictures/profile_picture_default_male.png"
        : "assets/pictures/profile_picture_default_female.png";
    var _pictureWidth = StaticFunctions.getDeviceWidth(context) * 0.6;
    var _pictureHeight = StaticFunctions.getDeviceHeight(context) * 0.35;
    var _fullAdress = "${_userDetails.address1} ${_userDetails.address2} ${_userDetails.address3}";

    return Scaffold(
      appBar: CustomAppBar(
        title: "Personal Information",
      ),
      body: SingleChildScrollView(
        padding: ThemeDesign.containerPaddingAll,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Stack(
                alignment: Alignment.bottomRight,
                children: <Widget>[
                  _userImage == null
                      ? ClipOval(
                          child: Image.asset(
                            _genderImage,
                            width: _pictureWidth,
                            height: _pictureHeight,
                            fit: BoxFit.cover,
                          ),
                        )
                      : ClipOval(
                          child: Image.memory(
                            _userImage,
                            width: _pictureWidth,
                            height: _pictureHeight,
                            fit: BoxFit.cover,
                          ),
                        ),
                  Padding(
                    padding: EdgeInsets.all(0),
                    child: ClipOval(
                      child: Container(
                        color: ThemeDesign.appPrimaryColor,
                        child: IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => AccountUpdateProfilePicturePage(
                                  userDetails: _userDetails,
                                  defaultGenderImage: _genderImage,
                                  pictureWidth: _pictureWidth,
                                  pictureHeight: _pictureHeight,
                                ),
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              CustomSizedBox(),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Table(
                    columnWidths: {
                      0: FractionColumnWidth(0.25),
                      1: FractionColumnWidth(0.02),
                      2: FractionColumnWidth(0.63),
                      3: FractionColumnWidth(0.1),
                    },
                    children: [
                      TableRow(
                        children: [
                          _text("NRIC/ID No."),
                          _text(": "),
                          _text("${_userDetails.idNo}"),
                          _text(""),
                        ],
                      ),
                      TableRow(
                        children: [
                          _text("Date of Birth"),
                          _text(": "),
                          _text("${_userDetails.birthday}"),
                          _text(""),
                        ],
                      ),
                      TableRow(
                        children: [
                          _text("Gender"),
                          _text(": "),
                          _text("${_userDetails.gender}"),
                          _text(""),
                        ],
                      ),
                      TableRow(
                        children: [
                          _text("Mobile No."),
                          _text(": "),
                          _text("${_userDetails.mobileNo}"),
                          _text(""),
                        ],
                      ),
                      TableRow(
                        children: [
                          _text("Address"),
                          _text(": "),
                          _text("$_fullAdress"),
                          _text(""),
                        ],
                      ),
                      TableRow(
                        children: [
                          _text("Postcode"),
                          _text(": "),
                          _text("${_userDetails.postcode}"),
                          _text(""),
                        ],
                      ),
                      TableRow(
                        children: [
                          _text("Town/City"),
                          _text(": "),
                          _text("${_userDetails.townCity}"),
                          _text(""),
                        ],
                      ),
                      TableRow(
                        children: [
                          _text("State"),
                          _text(": "),
                          _text("${_userDetails.stateName}"),
                          _text(""),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FabCircularMenu(
        key: _fabKey,
        fabElevation: 0,
        fabCloseColor: ThemeDesign.appPrimaryColor,
        fabOpenColor: ThemeDesign.appPrimaryColor,
        fabOpenIcon: Icon(
          Icons.menu,
          color: Colors.white,
        ),
        fabCloseIcon: Icon(
          Icons.close,
          color: Colors.white,
        ),
        ringColor: ThemeDesign.appPrimaryColor900,
        ringDiameter: StaticFunctions.getDeviceWidth(context),
        children: <Widget>[
          _fabSingleMenu(
            Icons.edit,
            () {
              _fabKey.currentState.close();

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => AccountUpdateDetailsPage(
                    userDetails: _userDetails,
                  ),
                ),
              );
            },
          ),
          _fabSingleMenu(
            Icons.lock,
            () {
              _fabKey.currentState.close();

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => ChangePasswordPage(
                    userDetails: _userDetails,
                  ),
                ),
              );
            },
          ),
          null,
        ],
      ),
      // floatingActionButton: Column(
      //   mainAxisSize: MainAxisSize.min,
      //   children: <Widget>[
      //     FloatingActionButton(
      //       tooltip: "Update Details",
      //       mini: true,
      //       heroTag: null,
      //       onPressed: () {
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //             builder: (BuildContext context) => AccountUpdateDetailsPage(
      //               userDetails: _userDetails,
      //             ),
      //           ),
      //         );
      //       },
      //       child: Icon(
      //         Icons.edit,
      //         color: Colors.white,
      //       ),
      //       backgroundColor: ThemeDesign.appPrimaryColor,
      //     ),
      //     FloatingActionButton(
      //       tooltip: "Change Password",
      //       mini: true,
      //       heroTag: null,
      //       onPressed: () {
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //             builder: (BuildContext context) => ChangePasswordPage(
      //               userDetails: _userDetails,
      //             ),
      //           ),
      //         );
      //       },
      //       child: Icon(
      //         Icons.lock,
      //         color: Colors.white,
      //       ),
      //       backgroundColor: ThemeDesign.appPrimaryColor,
      //     ),
      //   ],
      // ),
    );
  }

  Container _text(String text) {
    return Container(
      padding: ThemeDesign.containerPaddingAll,
      child: Text(
        text,
        style: ThemeDesign.descriptionStyle,
      ),
    );
  }

  Widget _fabSingleMenu(IconData icon, Function onPressFunction) {
    return SizedBox(
      width: 75,
      height: 75,
      child: RaisedButton(
        color: ThemeDesign.appPrimaryColor,
        child: Icon(
          icon,
          color: Colors.white,
          size: 40,
        ),
        onPressed: onPressFunction,
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(60.0),
        ),
      ),
    );
  }
}
