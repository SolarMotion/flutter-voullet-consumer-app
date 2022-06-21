import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './enums/generic_enums.dart';
import './helpers/custom_shared_preferences.dart';
import './pages/generic_pages/bottom_navigation_bar_page.dart';
import './pages/shared_pages/loading_page.dart';
import './pages/account_pages/login_page.dart';
import './resources/theme_designs.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: ThemeDesign.appPrimaryColor900,
      systemNavigationBarColor: ThemeDesign.appPrimaryColor900,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
    ));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: ThemeDesign.appPrimaryColor,
        accentColor: ThemeDesign.appPrimaryColor300,
      ),
      home: FutureBuilder(
        future: CustomSharedPreferences.getValue(StorageEnum.userID),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return snapshot.hasData ? BottomNavigationBarPage() : LoginPage();
          } else {
            return LoadingPage();
          }
        },
      ),
    );
  }
}
