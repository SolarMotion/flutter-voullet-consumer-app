import 'dart:convert';
import 'dart:typed_data';

import './../helpers/custom_http_clients.dart';

class BulletinApis {
  static Future<BulletinImageSlideResponse> bulletinImageSlideApi() async {
    try {
      var response = await CustomHttpClient.customHttpPostNoRequest("/GetBeanBagImagesSlide");

      return BulletinImageSlideResponse.fromJson(response);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  static Future<BulletinDetailsResponse> bulletinDetailsApi(BulletinDetailsRequest request) async {
    try {
      var response = await CustomHttpClient.customHttpPost(request, "/GetBulletinInfo");

      return BulletinDetailsResponse.fromJson(response);
    } catch (e) {
      print(e);
      throw e;
    }
  }
}

class BulletinImageSlideResponse {
  String error;
  List<BulletinImageSlideItem> items;

  BulletinImageSlideResponse({this.error, this.items});

  factory BulletinImageSlideResponse.fromJson(Map<String, dynamic> parsedJson) {
    return BulletinImageSlideResponse(
      error: parsedJson['Error'],
      items: (parsedJson['BeanBagImagesSlideList'] as List).map((i) => BulletinImageSlideItem.fromJson(i)).toList(),
    );
  }
}

class BulletinImageSlideItem {
  Uint8List imageBytes;
  int bulletinID;

  BulletinImageSlideItem({this.bulletinID, this.imageBytes});

  factory BulletinImageSlideItem.fromJson(Map<String, dynamic> parsedJson) {
    return BulletinImageSlideItem(
      bulletinID: parsedJson['BulletinID'],
      imageBytes: base64.decode(parsedJson['ImageStr'] == null ? null : parsedJson['ImageStr']),
    );
  }
}

class BulletinDetailsRequest {
  int bulletinID;
  int userID;

  BulletinDetailsRequest(this.bulletinID, this.userID);

  Map<String, dynamic> toJson() => {
        "BulletinID": bulletinID,
        "UserId": userID,
      };
}

class BulletinDetailsResponse {
  String subject;
  String body;
  String error;

  BulletinDetailsResponse({this.subject, this.body, this.error});

  factory BulletinDetailsResponse.fromJson(Map<String, dynamic> parsedJson) {
    return BulletinDetailsResponse(
      subject: parsedJson['Subject'],
      body: parsedJson['Body'],
      error: parsedJson['Error'],
    );
  }
}
