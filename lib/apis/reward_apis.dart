import 'dart:convert';
import 'dart:typed_data';

import './../helpers/custom_http_clients.dart';

class RewardApis {
  static Future<RewardOrgResponse> rewardOrgApi(RewardOrgRequest request) async {
    try {
      var response = await CustomHttpClient.customHttpPost(request, "/GetOrgs");

      return RewardOrgResponse.fromJson(response);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  static Future<RewardStampDetailsResponse> rewardStampDetailsApi(RewardStampDetailsRequest request) async {
    try {
      var response = await CustomHttpClient.customHttpPost(request, "/GetStampTiers");

      return RewardStampDetailsResponse.fromJson(response);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  static Future<RewardStampSubscribeResponse> rewardSubscribeApi(RewardStampSubscribeRequest request) async {
    try {
      var response = await CustomHttpClient.customHttpPost(request, "/CreateStampBalance");

      return RewardStampSubscribeResponse.fromJson(response);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  static Future<RewardStampBalanceOrgResponse> rewardStampBalanceOrgApi(RewardStampBalanceOrgRequest request) async {
    try {
      var response = await CustomHttpClient.customHttpPost(request, "/GetStampBalancesOrg");

      return RewardStampBalanceOrgResponse.fromJson(response);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  static Future<RewardStampBalancesResponse> rewardStampBalancesApi(RewardStampBalancesRequest request) async {
    try {
      var response = await CustomHttpClient.customHttpPost(request, "/GetStampBalances");

      return RewardStampBalancesResponse.fromJson(response);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  static Future<RewardStampBalanceDetailsResponse> rewardStampBalanceDetailsApi(RewardStampBalanceDetailsRequest request) async {
    try {
      var response = await CustomHttpClient.customHttpPost(request, "/GetStampBalance");

      return RewardStampBalanceDetailsResponse.fromJson(response);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  static Future<RewardScanCodeResponse> rewardScanCodeApi(RewardScanCodeRequest request) async {
    try {
      var response = await CustomHttpClient.customHttpPost(request, "/ScanCode");

      return RewardScanCodeResponse.fromJson(response);
    } catch (e) {
      print(e);
      throw e;
    }
  }
}

class RewardOrgRequest {
  int userID;
  int orgID;

  RewardOrgRequest(this.userID, this.orgID);

  Map<String, dynamic> toJson() => {
        "UserId": userID,
        "orgID": orgID,
      };
}

class RewardOrgResponse {
  List<RewardOrgItem> rewardOrgItems;
  String error;

  RewardOrgResponse({this.rewardOrgItems, this.error});

  factory RewardOrgResponse.fromJson(Map<String, dynamic> parsedJson) {
    return RewardOrgResponse(
      rewardOrgItems: (parsedJson['getOrgsList'] as List).map((i) => RewardOrgItem.fromJson(i)).toList(),
      error: parsedJson['Error'],
    );
  }
}

class RewardOrgItem {
  int orgID;
  int stampID;
  Uint8List orgImageBytes;

  RewardOrgItem({
    this.orgID,
    this.stampID,
    this.orgImageBytes,
  });

  factory RewardOrgItem.fromJson(Map<String, dynamic> parsedJson) {
    return RewardOrgItem(
      orgID: parsedJson['orgID'],
      stampID: parsedJson['stampID'],
      orgImageBytes: base64.decode(parsedJson['logoStr'] == null ? null : parsedJson['logoStr']),
    );
  }
}

class RewardStampDetailsRequest {
  int stampID;
  int userID;

  RewardStampDetailsRequest(this.stampID, this.userID);

  Map<String, dynamic> toJson() => {
        "stampID": stampID,
        "UserId": userID,
      };
}

class RewardStampDetailsResponse {
  int stampID;
  String stampName;
  String orgName;
  Uint8List stampImageBytes;

  List<RewardStampTierItem> stampTiers;
  String error;

  RewardStampDetailsResponse({this.stampID, this.stampName, this.orgName, this.stampImageBytes, this.stampTiers, this.error});

  factory RewardStampDetailsResponse.fromJson(Map<String, dynamic> parsedJson) {
    return RewardStampDetailsResponse(
      stampID: parsedJson['stampID'],
      stampName: parsedJson['stampName'],
      orgName: parsedJson['orgName'],
      stampImageBytes: base64.decode(parsedJson['stampImgStr'] == null ? null : parsedJson['stampImgStr']),
      stampTiers: (parsedJson['stampTiers'] as List).map((i) => RewardStampTierItem.fromJson(i)).toList(),
      error: parsedJson['Error'],
    );
  }
}

class RewardStampTierItem {
  String stampTierName;
  String stampTierDescription;
  int stampQuantity;
  Uint8List stampTierImageBytes;

  RewardStampTierItem({
    this.stampTierName,
    this.stampTierDescription,
    this.stampQuantity,
    this.stampTierImageBytes,
  });

  factory RewardStampTierItem.fromJson(Map<String, dynamic> parsedJson) {
    return RewardStampTierItem(
      stampTierName: parsedJson['name'],
      stampTierDescription: parsedJson['desc'],
      stampQuantity: parsedJson['qty'],
      stampTierImageBytes: base64.decode(parsedJson['imageStr'] == null ? null : parsedJson['imageStr']),
    );
  }
}

class RewardStampSubscribeRequest {
  int stampID;
  int userID;

  RewardStampSubscribeRequest(this.stampID, this.userID);

  Map<String, dynamic> toJson() => {
        "stampID": stampID,
        "UserId": userID,
      };
}

class RewardStampSubscribeResponse {
  int stampID;
  int stampBalanceID;
  String error;

  RewardStampSubscribeResponse({this.stampID, this.stampBalanceID, this.error});

  factory RewardStampSubscribeResponse.fromJson(Map<String, dynamic> parsedJson) {
    return RewardStampSubscribeResponse(
      stampID: parsedJson['stampID'],
      stampBalanceID: parsedJson['stampBalanceID'],
      error: parsedJson['Error'],
    );
  }
}

class RewardStampBalanceOrgRequest {
  int userID;

  RewardStampBalanceOrgRequest(this.userID);

  Map<String, dynamic> toJson() => {
        "UserId": userID,
      };
}

class RewardStampBalanceOrgResponse {
  List<RewardStampBalanceOrgItem> rewardStampBalanceOrgItems;
  String error;

  RewardStampBalanceOrgResponse({this.rewardStampBalanceOrgItems, this.error});

  factory RewardStampBalanceOrgResponse.fromJson(Map<String, dynamic> parsedJson) {
    return RewardStampBalanceOrgResponse(
      rewardStampBalanceOrgItems: (parsedJson['getStampBalancesOrgList'] as List).map((i) => RewardStampBalanceOrgItem.fromJson(i)).toList(),
      error: parsedJson['Error'],
    );
  }
}

class RewardStampBalanceOrgItem {
  int orgID;
  Uint8List orgImageBytes;

  RewardStampBalanceOrgItem({
    this.orgID,
    this.orgImageBytes,
  });

  factory RewardStampBalanceOrgItem.fromJson(Map<String, dynamic> parsedJson) {
    return RewardStampBalanceOrgItem(
      orgID: parsedJson['orgID'],
      orgImageBytes: base64.decode(parsedJson['orgImgStr'] == null ? null : parsedJson['orgImgStr']),
    );
  }
}

class RewardStampBalancesRequest {
  int orgID;
  int userID;

  RewardStampBalancesRequest(this.orgID, this.userID);

  Map<String, dynamic> toJson() => {
        "orgID": orgID,
        "UserId": userID,
      };
}

class RewardStampBalancesResponse {
  List<RewardStampBalancesItem> rewardStampBalanceItems;
  String error;

  RewardStampBalancesResponse({this.rewardStampBalanceItems, this.error});

  factory RewardStampBalancesResponse.fromJson(Map<String, dynamic> parsedJson) {
    return RewardStampBalancesResponse(
      rewardStampBalanceItems: (parsedJson['getStampBalancesList'] as List).map((i) => RewardStampBalancesItem.fromJson(i)).toList(),
      error: parsedJson['Error'],
    );
  }
}

class RewardStampBalancesItem {
  int stampID;
  Uint8List stampImageBytes;

  RewardStampBalancesItem({
    this.stampID,
    this.stampImageBytes,
  });

  factory RewardStampBalancesItem.fromJson(Map<String, dynamic> parsedJson) {
    return RewardStampBalancesItem(
      stampID: parsedJson['orgStampID'],
      stampImageBytes: base64.decode(parsedJson['stampImgStr'] == null ? null : parsedJson['stampImgStr']),
    );
  }
}

class RewardStampBalanceDetailsRequest {
  int stampID;
  int userID;

  RewardStampBalanceDetailsRequest(this.stampID, this.userID);

  Map<String, dynamic> toJson() => {
        "stampID": stampID,
        "UserId": userID,
      };
}

class RewardStampBalanceDetailsResponse {
  String stampName;
  int stampQty;
  Uint8List stampImageBytes;
  List<RewardStampBalanceTierItem> rewardStampBalanceItems;
  String error;

  RewardStampBalanceDetailsResponse({this.stampName, this.stampQty, this.stampImageBytes, this.rewardStampBalanceItems, this.error});

  factory RewardStampBalanceDetailsResponse.fromJson(Map<String, dynamic> parsedJson) {
    return RewardStampBalanceDetailsResponse(
      stampName: parsedJson['name'],
      stampQty: parsedJson['bal'],
      stampImageBytes: base64.decode(parsedJson['stampImgStr'] == null ? null : parsedJson['stampImgStr']),
      rewardStampBalanceItems: (parsedJson['stampBalanceTierDetails'] as List).map((i) => RewardStampBalanceTierItem.fromJson(i)).toList(),
      error: parsedJson['Error'],
    );
  }
}

class RewardStampBalanceTierItem {
  String tierName;
  String tierDescription;
  int tierQty;
  String redeemCode;
  Uint8List stampImageBytes;

  RewardStampBalanceTierItem({
    this.tierName,
    this.tierDescription,
    this.tierQty,
    this.redeemCode,
    this.stampImageBytes,
  });

  factory RewardStampBalanceTierItem.fromJson(Map<String, dynamic> parsedJson) {
    return RewardStampBalanceTierItem(
      tierName: parsedJson['tierName'],
      tierDescription: parsedJson['tierDesc'],
      tierQty: parsedJson['tierQty'],
      redeemCode: parsedJson['redeemCode'],
      stampImageBytes: base64.decode(parsedJson['stampTierImgStr'] == null ? null : parsedJson['stampTierImgStr']),
    );
  }
}

class RewardScanCodeRequest {
  String code;
  int userID;

  RewardScanCodeRequest(this.code, this.userID);

  Map<String, dynamic> toJson() => {
        "scanCode": code,
        "UserId": userID,
      };
}

class RewardScanCodeResponse {
  String scanMessage;
  String error;

  RewardScanCodeResponse({this.scanMessage, this.error});

  factory RewardScanCodeResponse.fromJson(Map<String, dynamic> parsedJson) {
    return RewardScanCodeResponse(
      scanMessage: parsedJson['scanMessage'],
      error: parsedJson['Error'],
    );
  }
}
