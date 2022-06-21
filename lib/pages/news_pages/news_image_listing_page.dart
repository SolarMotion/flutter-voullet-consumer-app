import 'dart:async';
import 'package:flutter/material.dart';

import './../../apis/news_apis.dart';
import './../../helpers/static_functions.dart';
import './../../pages/shared_pages/empty_page.dart';
import './../../resources/theme_designs.dart';
import './../../widgets/custom_app_bar.dart';
import './../../helpers/extension_functions.dart';

class NewsImageListingPage extends StatefulWidget {
  final String orgName;
  final int imageIndex;
  final List<NewsImageItem> newsImages;

  NewsImageListingPage({Key key, @required this.orgName, @required this.imageIndex, @required this.newsImages})
      : super(key: key);

  @override
  _NewsImageListingPageState createState() => _NewsImageListingPageState();
}

class _NewsImageListingPageState extends State<NewsImageListingPage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _deviceHeight = StaticFunctions.getDeviceHeight(context);
    final _imageHeight = _deviceHeight * 0.75;

    Timer(Duration(milliseconds: 50), () {
      _scrollController.jumpTo(_imageHeight * widget.imageIndex);
    });

    return Scaffold(
      appBar: CustomAppBar(
        title: widget.orgName,
        centerTitle: true,
      ),
      body: widget.newsImages.isListEmpty()
          ? EmptyPage()
          : 
          ListView.builder(
              padding: ThemeDesign.containerPaddingLeftRightBottom,
              controller: _scrollController,
              shrinkWrap: true,
              itemCount: widget.newsImages.length,
              itemBuilder: (context, index) {
                final _newsImage = widget.newsImages[index];

                return Container(
                  height: _imageHeight,
                  child: Card(
                    shape: ThemeDesign.cardBorderStyle,
                    margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(ThemeDesign.cardCornerRadius)),
                        child: Image.memory(
                          _newsImage.imageBytes,
                          fit: BoxFit.fill,
                        ),
                      ),
                      onTap: () {},
                    ),
                  ),
                );
              },
            ),
    );
  }
}
