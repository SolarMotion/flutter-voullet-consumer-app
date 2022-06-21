import 'package:flutter/material.dart';
import 'package:flutter_voullet_consumer_app/widgets/custom_sized_box.dart';

import './../../helpers/custom_url_launchers.dart';
import './../../pages/help_pages/help_feedback_form_page.dart';
import './../../resources/theme_designs.dart';
import './../../widgets/custom_app_bar.dart';

class HelpIndexPage extends StatefulWidget {
  @override
  _HelpIndexPageState createState() => _HelpIndexPageState();
}

class _HelpIndexPageState extends State<HelpIndexPage> {
  final double _padding = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Help",
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(ThemeDesign.containerPadding),
          child: Column(
            children: <Widget>[
              Card(
                elevation: 10,
                child: ListTile(
                  contentPadding: EdgeInsets.all(_padding),
                  title: Container(
                    padding: EdgeInsets.only(bottom: _padding),
                    child: Text(
                      "FAQ",
                      style: _titleStyle(),
                    ),
                  ),
                  subtitle: Text.rich(
                    TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Please visit our',
                          style: ThemeDesign.descriptionStyle,
                        ),
                        TextSpan(
                            text: ' site ',
                            style: TextStyle(
                              fontSize: ThemeDesign.descriptionFontSize,
                              decoration: TextDecoration.underline,
                              color: Colors.blue,
                            )),
                        TextSpan(
                          text: 'for more details.',
                          style: ThemeDesign.descriptionStyle,
                        ),
                      ],
                    ),
                  ),
                  onTap: () async {
                    await CustomUrlLauncher.launchInBrowser("https://www.google.com");
                  },
                ),
              ),
              CustomSizedBox(),
              Card(
                elevation: 10,
                child: ListTile(
                  contentPadding: EdgeInsets.all(_padding),
                  title: Container(
                    padding: EdgeInsets.only(bottom: _padding),
                    child: Text(
                      "Support Contacts",
                      style: _titleStyle(),
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      RichText(
                        textScaleFactor: 1.1,
                        text: TextSpan(
                          style: Theme.of(context).textTheme.caption,
                          children: [
                            WidgetSpan(
                              child: Icon(Icons.email),
                            ),
                            TextSpan(
                              text: " admin@voullet.com",
                              style: ThemeDesign.descriptionStyle,
                            ),
                          ],
                        ),
                      ),
                      RichText(
                        textScaleFactor: 1.1,
                        text: TextSpan(
                          style: Theme.of(context).textTheme.caption,
                          children: [
                            WidgetSpan(
                              child: Icon(Icons.phone),
                            ),
                            TextSpan(
                              text: " +60123456789",
                              style: ThemeDesign.descriptionStyle,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              CustomSizedBox(),
              Card(
                elevation: 10,
                child: ListTile(
                  contentPadding: EdgeInsets.all(_padding),
                  title: Container(
                    padding: EdgeInsets.only(bottom: _padding),
                    child: Text(
                      "Feedback Form",
                      style: _titleStyle(),
                    ),
                  ),
                  subtitle: Text.rich(
                    TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Click',
                          style: ThemeDesign.descriptionStyle,
                        ),
                        TextSpan(
                            text: ' here ',
                            style: TextStyle(
                              fontSize: ThemeDesign.descriptionFontSize,
                              decoration: TextDecoration.underline,
                              color: Colors.blue,
                            )),
                        TextSpan(
                          text: 'to send us a feedback.',
                          style: ThemeDesign.descriptionStyle,
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => HelpFeedbackFormPage(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle _titleStyle() {
    return TextStyle(
      fontSize: ThemeDesign.titleFontSize,
      color: ThemeDesign.appPrimaryColor900,
      fontWeight: FontWeight.bold,
    );
  }
}
