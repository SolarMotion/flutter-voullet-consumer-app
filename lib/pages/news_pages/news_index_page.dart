import 'package:flutter/material.dart';

import './../../helpers/static_functions.dart';
import './../../models/voucher_design_models.dart';
import './../../pages/news_pages/news_image_listing_page.dart';
import './../../pages/shared_pages/error_page.dart';
import './../../pages/voucher_pages/voucher_details_page.dart';
import './../../resources/app_settings.dart';
import './../../widgets/custom_sized_box.dart';
import './../../apis/news_apis.dart';
import './../../enums/generic_enums.dart';
import './../../helpers/custom_shared_preferences.dart';
import './../../pages/shared_pages/empty_page.dart';
import './../../pages/shared_pages/loading_page.dart';
import './../../resources/theme_designs.dart';
import './../../widgets/custom_app_bar.dart';
import './../../helpers/extension_functions.dart';

class NewsIndexPage extends StatefulWidget {
  @override
  _NewsIndexPageState createState() => _NewsIndexPageState();
}

class _NewsIndexPageState extends State<NewsIndexPage> {
  bool _isFirstLoad = true;
  final double _imageHeight = 0.4;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getNewsDetails(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData && !_isFirstLoad) {
          return snapshot.data;
        } else if (_isFirstLoad) {
          return Scaffold(
            appBar: CustomAppBar(
              showHighlight: true,
            ),
            body: LoadingPage(),
          );
        } else {
          return snapshot.data;
        }
      },
    );
  }

  Future<Widget> _getNewsDetails() async {
    final int _userID = (await CustomSharedPreferences.getValue(StorageEnum.userID)).toInt();
    NewsListingRequest _newsListingRequest = NewsListingRequest(_userID);
    NewsListingResponse _newsListingResponse = await NewsApi.newsListingApi(_newsListingRequest);
    _isFirstLoad = false;

    return Scaffold(
      appBar: CustomAppBar(
        showHighlight: true,
      ),
      body: _newsListingResponse.error.isStringEmpty()
          ? Container(
              child: _newsListingResponse.newsItems.isListEmpty()
                  ? EmptyPage()
                  : RefreshIndicator(
                      onRefresh: () async {
                        final _refreshedNewsListingResponse = await NewsApi.newsListingApi(_newsListingRequest);

                        setState(() {
                          _newsListingResponse = _refreshedNewsListingResponse;
                        });
                      },
                      child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        padding: ThemeDesign.containerPaddingLeftRightBottom,
                        child: _constructNewsList(_newsListingResponse.newsItems),
                      ),
                    ),
            )
          : ErrorPage(text: _newsListingResponse.error),
    );
  }

  Widget _constructNewsList(List<NewsItem> newsItems) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: newsItems.length,
      itemBuilder: (context, index) {
        final _newsItem = newsItems[index];

        return Card(
          shape: ThemeDesign.cardBorderStyle,
          margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Padding(
              padding: EdgeInsets.all(ThemeDesign.containerPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Image.memory(
                        _newsItem.newsOrgImage.imageBytes,
                        height: StaticFunctions.getDeviceHeight(context) * 0.05,
                        width: StaticFunctions.getDeviceWidth(context) * 0.2,
                        fit: BoxFit.fitWidth,
                      ),
                      SizedBox(width: 5),
                      Text(
                        _newsItem.newsOrgName,
                        style: ThemeDesign.titleStyleWithColourLarge,
                      ),
                    ],
                  ),
                  CustomSizedBox(height: 10),
                  _constructImageArea(_newsItem),
                  ..._constructVoucherDesigns(_newsItem.vouchers),
                  CustomSizedBox(height: 10),
                  Text(
                    _newsItem.newsSubject,
                    style: ThemeDesign.titleStyleWithColourRegular,
                  ),
                  Text(
                    _newsItem.newsBody,
                    style: ThemeDesign.emptyStyle,
                  ),
                ],
              ),
            ),
            // onTap: () {
            //   if (!_newsItem.newsImages.isListEmpty()) {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (BuildContext context) => NewsImageListingPage(
            //           newsImages: _newsItem.newsImages,
            //           orgName: _newsItem.newsOrgName,
            //           imageIndex: ,
            //         ),
            //         fullscreenDialog: true,
            //       ),
            //     );
            //   }
            // },
          ),
        );
      },
    );
  }

  Widget _constructImageArea(NewsItem newsItem) {
    if (newsItem.newsImages.isListEmpty()) {
      return Container();
    }

    if (newsItem.newsImages.length == 1) {
      return _constructOneImage(newsItem);
    }

    if (newsItem.newsImages.length == 2) {
      return _constructTwoImages(newsItem);
    }

    //For 3 or more images
    return _constructThreeImages(newsItem);
  }

  BoxDecoration _imageBoxDecoration() {
    return BoxDecoration(
      border: Border.all(
        color: Colors.grey,
      ),
    );
  }

  Widget _constructOneImage(NewsItem newsItem) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Container(
        decoration: _imageBoxDecoration(),
        child: InkWell(
          child: Image.memory(
            newsItem.newsImages[0].imageBytes,
            width: double.infinity,
            height: StaticFunctions.getDeviceHeight(context) * _imageHeight,
            fit: BoxFit.fill,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => NewsImageListingPage(
                  newsImages: newsItem.newsImages,
                  orgName: newsItem.newsOrgName,
                  imageIndex: 0,
                ),
                fullscreenDialog: true,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _constructTwoImages(NewsItem newsItem) {
    final _deviceWidth = StaticFunctions.getDeviceWidth(context);
    final _deviceHeight = StaticFunctions.getDeviceHeight(context);
    final _imageWidth = 0.44;

    return Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Row(
        children: <Widget>[
          Container(
            decoration: _imageBoxDecoration(),
            child: InkWell(
              child: Image.memory(
                newsItem.newsImages[0].imageBytes,
                height: _deviceHeight * _imageHeight,
                width: _deviceWidth * _imageWidth,
                fit: BoxFit.fill,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => NewsImageListingPage(
                      newsImages: newsItem.newsImages,
                      orgName: newsItem.newsOrgName,
                      imageIndex: 0,
                    ),
                    fullscreenDialog: true,
                  ),
                );
              },
            ),
          ),
          Spacer(),
          Container(
            decoration: _imageBoxDecoration(),
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.grey,
                BlendMode.modulate,
              ),
              child: InkWell(
                child: Image.memory(
                  newsItem.newsImages[1].imageBytes,
                  height: _deviceHeight * _imageHeight,
                  width: _deviceWidth * _imageWidth,
                  fit: BoxFit.fill,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => NewsImageListingPage(
                        newsImages: newsItem.newsImages,
                        orgName: newsItem.newsOrgName,
                        imageIndex: 1,
                      ),
                      fullscreenDialog: true,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _constructThreeImages(NewsItem newsItem) {
    final _deviceWidth = StaticFunctions.getDeviceWidth(context);
    final _deviceHeight = StaticFunctions.getDeviceHeight(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            decoration: _imageBoxDecoration(),
            child: InkWell(
              child: Image.memory(
                newsItem.newsImages[0].imageBytes,
                width: _deviceWidth * 0.6,
                height: _deviceHeight * _imageHeight,
                fit: BoxFit.fitHeight,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => NewsImageListingPage(
                      newsImages: newsItem.newsImages,
                      orgName: newsItem.newsOrgName,
                      imageIndex: 0,
                    ),
                    fullscreenDialog: true,
                  ),
                );
              },
            ),
          ),
          Spacer(),
          Container(
            height: _deviceHeight * _imageHeight,
            child: Column(
              children: <Widget>[
                Container(
                  decoration: _imageBoxDecoration(),
                  child: InkWell(
                    child: Image.memory(
                      newsItem.newsImages[1].imageBytes,
                      height: _deviceHeight * _imageHeight / 2.05,
                      width: _deviceWidth * 0.28,
                      fit: BoxFit.fitHeight,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => NewsImageListingPage(
                            newsImages: newsItem.newsImages,
                            orgName: newsItem.newsOrgName,
                            imageIndex: 1,
                          ),
                          fullscreenDialog: true,
                        ),
                      );
                    },
                  ),
                ),
                Spacer(),
                InkWell(
                  child: Container(
                    decoration: _imageBoxDecoration(),
                    child: newsItem.newsImages.length == 3
                        ? Image.memory(
                            newsItem.newsImages[2].imageBytes,
                            height: _deviceHeight * _imageHeight / 2.05,
                            width: _deviceWidth * 0.28,
                            fit: BoxFit.fitHeight,
                          )
                        : Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              ColorFiltered(
                                colorFilter: ColorFilter.mode(
                                  Colors.grey,
                                  BlendMode.modulate,
                                ),
                                child: Image.memory(
                                  newsItem.newsImages[2].imageBytes,
                                  height: _deviceHeight * _imageHeight / 2.05,
                                  width: _deviceWidth * 0.28,
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                              Text(
                                "+ ${newsItem.newsImages.length - 3}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                ),
                              ),
                            ],
                          ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => NewsImageListingPage(
                          newsImages: newsItem.newsImages,
                          orgName: newsItem.newsOrgName,
                          imageIndex: 2,
                        ),
                        fullscreenDialog: true,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _constructVoucherDesigns(List<VoucherDesignModel> voucherDesigns) {
    return voucherDesigns.isListEmpty()
        ? [Container()]
        : [
            CustomSizedBox(height: 10),
            Text(
              "Voucher(s) / Coupon(s)",
              style: ThemeDesign.titleStyleWithColourRegular,
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: voucherDesigns.length,
              itemBuilder: (context, index) {
                final _voucherDesign = voucherDesigns[index];

                return Padding(
                  padding: ThemeDesign.containerPaddingTopBottom,
                  child: InkWell(
                    child: Row(
                      children: <Widget>[
                        ClipOval(
                          child: Image.memory(
                            _voucherDesign.voucherDesignImageBytes,
                            width: 40,
                          ),
                        ),
                        SizedBox(width: 2),
                        Flexible(
                          child: Text(
                            _voucherDesign.voucherDesignName,
                            style: ThemeDesign.emptyStyle,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 10,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => VoucherDetailsPage(
                            voucherDesignID: _voucherDesign.voucherDesignID,
                            redeemType: ButtonTypeEnum.download,
                            voucherType: _voucherDesign.voucherDesignTypeCode == AppSetting.voucherDesignTypeCoupon
                                ? VoucherTypeEnum.coupon
                                : VoucherTypeEnum.voucher,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ];
  }
}
