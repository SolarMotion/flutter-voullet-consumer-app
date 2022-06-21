import 'package:flutter/material.dart';

import './../resources/theme_designs.dart';
import './../pages/setting_pages/setting_index_page.dart';
import './../pages/highlight_pages/highlight_index_page.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool centerTitle;
  final bool showHighlight;
  final bool showSetting;
  final bool hideAppBar;

  const CustomAppBar({
    Key key,
    this.title = "Quill City Mall",
    this.centerTitle = false,
    this.showHighlight = false,
    this.showSetting = false,
    this.hideAppBar = false,
  }) : super(key: key);

  @override
  Size get preferredSize => new Size.fromHeight(hideAppBar ? 0 : 56);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(hideAppBar ? 0 : 56),
      child: AppBar(
        brightness: Brightness.dark,
        iconTheme: IconThemeData(
          color: ThemeDesign.appPrimaryColor900,
        ),
        backgroundColor: Colors.white,
        title: Text(
          title,
          style: TextStyle(
            color: ThemeDesign.appPrimaryColor900,
            fontSize: ThemeDesign.titleFontSize,
          ),
        ),
        centerTitle: centerTitle,
        actions: <Widget>[
          showHighlight
              ? IconButton(
                  icon: Icon(
                    Icons.stars,
                    color: ThemeDesign.appPrimaryColor900,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => HighlightIndexPage(),
                      ),
                    );
                  },
                )
              : Container(),
          showSetting
              ? IconButton(
                  icon: Icon(
                    Icons.settings,
                    color: ThemeDesign.appPrimaryColor900,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => SettingIndexPage(),
                      ),
                    );
                  },
                )
              : Container(),
        ],
      ),
    );
  }
}
