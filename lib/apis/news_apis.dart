import 'dart:convert';
import 'dart:typed_data';

import './../helpers/custom_http_clients.dart';
import './../models/voucher_design_models.dart';

class NewsApi {
  static Future<NewsListingResponse> newsListingApi(NewsListingRequest request) async {
    try {
      var response = await CustomHttpClient.customHttpPost(request, "/GetNewsList");

      return NewsListingResponse.fromJson(response);
    } catch (e) {
      print(e);
      throw e;
    }
  }
}

class NewsListingRequest {
  int userID;

  NewsListingRequest(this.userID);

  Map<String, dynamic> toJson() => {
        "UserId": userID,
      };
}

class NewsListingResponse {
  List<NewsItem> newsItems;
  String error;

  NewsListingResponse({this.newsItems, this.error});

  factory NewsListingResponse.fromJson(Map<String, dynamic> parsedJson) {
    return NewsListingResponse(
      newsItems: (parsedJson['NewsInfoList'] as List).map((i) => NewsItem.fromJson(i)).toList(),
      error: parsedJson['Error'],
    );
  }
}

class NewsItem {
  int newsID;
  String newsSubject;
  String newsBody;
  String newsOrgName;
  NewsImageItem newsOrgImage;
  List<NewsImageItem> newsImages;
  List<VoucherDesignModel> vouchers;

  NewsItem({
    this.newsID,
    this.newsSubject,
    this.newsBody,
    this.newsOrgName,
    this.newsOrgImage,
    this.newsImages,
    this.vouchers,
  });

  factory NewsItem.fromJson(Map<String, dynamic> parsedJson) {
    return NewsItem(
      newsID: parsedJson['ID'],
      newsSubject: parsedJson['Subject'],
      newsBody: parsedJson['Body'],
      newsOrgName: parsedJson['OrgName'],
      newsOrgImage: NewsImageItem.fromJson(parsedJson['OrgImage']),
      newsImages: (parsedJson['NewsImageList'] as List).map((i) => NewsImageItem.fromJson(i)).toList(),
      vouchers: (parsedJson['VoucherList'] as List).map((i) => VoucherDesignModel.fromJson(i)).toList(),
    );
  }
}

class NewsImageItem {
  Uint8List imageBytes;

  NewsImageItem({this.imageBytes});

  factory NewsImageItem.fromJson(Map<String, dynamic> parsedJson) {
    return NewsImageItem(
      imageBytes: base64.decode(parsedJson['ImageStr'] == null ? null : parsedJson['ImageStr']),
    );
  }
}
