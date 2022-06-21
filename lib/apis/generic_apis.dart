import 'dart:convert';
import 'dart:typed_data';

import './../helpers/custom_http_clients.dart';

class GenericApis {
  static Future<CountryListingResponse> countryListingApi() async {
    var response = await CustomHttpClient.customHttpPostNoRequest("/GetCountryOptionList");

    return CountryListingResponse.fromJson(response);
  }

  static Future<StateListingResponse> stateListingApi(StateListingRequest request) async {
    var response = await CustomHttpClient.customHttpPostNoRequestObject(request, "/GetStateOptionList");

    return StateListingResponse.fromJson(response);
  }

  static Future<TransactionHistoryStampResponse> transactionHistoryStampApi(TransactionHistoryStampRequest request) async {
    var response = await CustomHttpClient.customHttpPost(request, "/GetCardTrans");
    return TransactionHistoryStampResponse.fromJson(response);

    // var item1 = TransactionHistoryStampItem(stampName: "AAAAA", transactionDate: "dsa dsad dsa", stampQuantity: 2, stampType: "R");
    // var item2 = TransactionHistoryStampItem(stampName: "AAAAA", transactionDate: "dsa dsad dsa", stampQuantity: 2, stampType: "S");
    // var item3 = TransactionHistoryStampItem(stampName: "AAAAA", transactionDate: "dsa dsad dsa", stampQuantity: 2, stampType: "R");
    // var items = [item1, item2, item3];

    // var response = TransactionHistoryStampResponse(items: items);

    // return response;
  }

  static Future<TransactionHistoryListingResponse> transactionHistoryListingResponseApi(TransactionHistoryListingRequest request) async {
    var response = await CustomHttpClient.customHttpPost(request, "/GetHistoryList");
    return TransactionHistoryListingResponse.fromJson(response);

    // var redeemItem1 = TransactionHistoryListingItem(
    //     voucherName: "AAA ZZZZZZZZ ZZZZZZZZZZZZ ZXXXXXXXA gfdgfdgfdgf", voucherDescription: "AAAA", voucherRedeemDate: "123 312", voucherRedeemTime: "ads", voucherStatus: "Redeem");
    // var redeemItem2 = TransactionHistoryListingItem(voucherName: "AAAA", voucherDescription: "AAAA", voucherRedeemDate: "123 312", voucherRedeemTime: "ads", voucherStatus: "Redeem");
    // var redeemItem3 = TransactionHistoryListingItem(voucherName: "AAAA", voucherDescription: "AAAA", voucherRedeemDate: "123 312", voucherRedeemTime: "ads", voucherStatus: "Redeem");
    // var redeemItems = [redeemItem1, redeemItem2, redeemItem3];

    // var expiredItem1 = TransactionHistoryListingItem(voucherName: "BBBB", voucherDescription: "AAAA", voucherRedeemDate: "123 312", voucherRedeemTime: "ads", voucherStatus: "Redeem");
    // var expiredItem2 = TransactionHistoryListingItem(voucherName: "BBBB", voucherDescription: "AAAA", voucherRedeemDate: "123 312", voucherRedeemTime: "ads", voucherStatus: "Redeem");
    // var expiredItem3 = TransactionHistoryListingItem(voucherName: "BBBB", voucherDescription: "AAAA", voucherRedeemDate: "123 312", voucherRedeemTime: "ads", voucherStatus: "Redeem");
    // var expiredItems = [expiredItem1, expiredItem2, expiredItem3];

    // var response = TransactionHistoryListingResponse(redeemedItems: redeemItems, expiredItems: expiredItems);

    // return response;
  }
}

class ListingItem {
  int value;
  String stringValue;
  String text;

  ListingItem({this.value, this.text, this.stringValue});

  factory ListingItem.fromJson(Map<String, dynamic> parsedJson) {
    return ListingItem(
      value: parsedJson['ID'],
      text: parsedJson['Name'],
    );
  }
}

class CountryListingResponse {
  int count;
  String error;
  List<ListingItem> items;

  CountryListingResponse({this.count, this.error, this.items});

  factory CountryListingResponse.fromJson(Map<String, dynamic> parsedJson) {
    return CountryListingResponse(
      count: parsedJson['Count'],
      error: parsedJson['Error'],
      items: (parsedJson['Items'] as List).map((i) => ListingItem.fromJson(i)).toList(),
    );
  }
}

class StateListingRequest {
  String countryID;

  StateListingRequest(this.countryID);

  Map<String, dynamic> toJson() => {
        "countryID": countryID,
      };
}

class StateListingResponse {
  int count;
  String error;
  List<ListingItem> items;

  StateListingResponse({this.count, this.error, this.items});

  factory StateListingResponse.fromJson(Map<String, dynamic> parsedJson) {
    return StateListingResponse(
      count: parsedJson['Count'],
      error: parsedJson['Error'],
      items: (parsedJson['Items'] as List).map((i) => ListingItem.fromJson(i)).toList(),
    );
  }
}

class TransactionHistoryStampRequest {
  int userID;

  TransactionHistoryStampRequest(this.userID);

  Map<String, dynamic> toJson() => {
        "UserId": userID,
      };
}

class TransactionHistoryStampResponse {
  String error;
  List<TransactionHistoryStampItem> items;

  TransactionHistoryStampResponse({this.error, this.items});

  factory TransactionHistoryStampResponse.fromJson(Map<String, dynamic> parsedJson) {
    return TransactionHistoryStampResponse(
      error: parsedJson['Error'],
      items: (parsedJson['cardTrans'] as List).map((i) => TransactionHistoryStampItem.fromJson(i)).toList(),
    );
  }
}

class TransactionHistoryStampItem {
  String stampType;
  Uint8List stampTierImageBytes;
  String stampName;
  int stampQuantity;
  Uint8List stampImageBytes;
  String transactionDate;

  TransactionHistoryStampItem({
    this.stampType,
    this.stampTierImageBytes,
    this.stampName,
    this.stampQuantity,
    this.stampImageBytes,
    this.transactionDate,
  });

  factory TransactionHistoryStampItem.fromJson(Map<String, dynamic> parsedJson) {
    return TransactionHistoryStampItem(
      stampType: parsedJson['type'],
      stampTierImageBytes: base64.decode(parsedJson['stampTierImgStr'] == null ? null : parsedJson['stampTierImgStr']),
      stampName: parsedJson['stampName'],
      stampQuantity: parsedJson['stampQty'],
      stampImageBytes: base64.decode(parsedJson['stampImgStr'] == null ? null : parsedJson['stampImgStr']),
      transactionDate: parsedJson['dateTime'],
    );
  }
}

class TransactionHistoryListingRequest {
  int userID;

  TransactionHistoryListingRequest(this.userID);

  Map<String, dynamic> toJson() => {
        "ID": userID,
      };
}

class TransactionHistoryListingResponse {
  String error;
  List<TransactionHistoryListingItem> redeemedItems;
  List<TransactionHistoryListingItem> expiredItems;

  TransactionHistoryListingResponse({
    this.error,
    this.redeemedItems,
    this.expiredItems,
  });

  factory TransactionHistoryListingResponse.fromJson(Map<String, dynamic> parsedJson) {
    return TransactionHistoryListingResponse(
      error: parsedJson['Error'],
      redeemedItems: (parsedJson['Redeemed'] as List).map((i) => TransactionHistoryListingItem.fromJson(i)).toList(),
      expiredItems: (parsedJson['Expired'] as List).map((i) => TransactionHistoryListingItem.fromJson(i)).toList(),
    );
  }
}

class TransactionHistoryListingItem {
  String voucherName;
  String voucherDescription;
  String voucherRedeemDate;
  String voucherRedeemTime;
  String voucherStatus;

  TransactionHistoryListingItem({
    this.voucherName,
    this.voucherDescription,
    this.voucherRedeemDate,
    this.voucherRedeemTime,
    this.voucherStatus,
  });

  factory TransactionHistoryListingItem.fromJson(Map<String, dynamic> parsedJson) {
    return TransactionHistoryListingItem(
      voucherName: parsedJson['Name'],
      voucherDescription: parsedJson['Description'],
      voucherRedeemDate: parsedJson['RedeemOn'],
      voucherRedeemTime: parsedJson['RedeemTime'],
      voucherStatus: parsedJson['Status'],
    );
  }
}
