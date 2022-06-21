import 'package:flutter/material.dart';

import './../../helpers/custom_shared_preferences.dart';
import './../../pages/account_pages/account_details_page.dart';
import './../../pages/account_pages/login_page.dart';
import './../../pages/help_pages/help_index_page.dart';
import './../../resources/theme_designs.dart';
import './../../widgets/custom_progress_dialog.dart';
import './../../widgets/custom_app_bar.dart';

class SettingIndexPage extends StatefulWidget {
  @override
  _SettingIndexPageState createState() => _SettingIndexPageState();
}

class _SettingIndexPageState extends State<SettingIndexPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: ListView(
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          Container(
            child: ListTile(
              leading: Icon(
                Icons.account_circle,
                color: ThemeDesign.appPrimaryColor900,
              ),
              title: Text(
                "Account Information",
                style: ThemeDesign.descriptionStyle,
              ),
              trailing: Wrap(
                spacing: 12,
                children: <Widget>[
                  Icon(
                    Icons.arrow_forward_ios,
                    color: ThemeDesign.appPrimaryColor900,
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => AccountDetailsPage(),
                  ),
                );
              },
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey),
              ),
            ),
          ),
          Container(
            child: ListTile(
              leading: Icon(
                Icons.help_outline,
                color: ThemeDesign.appPrimaryColor900,
              ),
              title: Text(
                "Help",
                style: ThemeDesign.descriptionStyle,
              ),
              trailing: Wrap(
                spacing: 12,
                children: <Widget>[
                  Icon(
                    Icons.arrow_forward_ios,
                    color: ThemeDesign.appPrimaryColor900,
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => HelpIndexPage(),
                  ),
                );
              },
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey),
              ),
            ),
          ),
          Container(
            child: ListTile(
              leading: Icon(
                Icons.power_settings_new,
                color: ThemeDesign.appPrimaryColor900,
              ),
              title: Text(
                "Logout",
                style: ThemeDesign.descriptionStyle,
              ),
              trailing: Wrap(
                spacing: 12,
                children: <Widget>[
                  Icon(
                    Icons.arrow_forward_ios,
                    color: ThemeDesign.appPrimaryColor900,
                  ),
                ],
              ),
              onTap: () async {
                CustomProgressDialog.show(context);
                await CustomSharedPreferences.removeAll();
                CustomProgressDialog.hide(context);

                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
