import 'dart:convert';
import 'dart:typed_data';

import './../models/voucher_models.dart';
import './../models/voucher_design_models.dart';
import './../helpers/custom_http_clients.dart';

class VoucherApis {
  static Future<VoucherDownloadResponse> voucherDownloadApi(VoucherDownloadRequest request) async {
    var response = await CustomHttpClient.customHttpPost(request, "/grabCoupon");

    return VoucherDownloadResponse.fromJson(response);
  }

  static Future<VoucherAvailableResponse> voucherAvailableApi() async {
    try {
      var response = await CustomHttpClient.customHttpPostNoRequest("/getAvaibleCouponVoucher");

      return VoucherAvailableResponse.fromJson(response);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  static Future<VoucherAvailableAllResponse> voucherAvailableAllApi(VoucherAvailableAllRequest request) async {
    var response = await CustomHttpClient.customHttpPost(request, "/getAllAvaibleCouponVoucher");

    return VoucherAvailableAllResponse.fromJson(response);
  }

  static Future<VoucherDetailsResponse> voucherDetailsApi(VoucherDetailsRequest request) async {
    var response = await CustomHttpClient.customHttpPost(request, "/GetVoucherDetail");

    return VoucherDetailsResponse.fromJson(response);
  }

  static Future<VoucherGetUserVoucherResponse> voucherGetUserVoucherApi(VoucherGetUserVoucherRequest request) async {
    try {
      var response = await CustomHttpClient.customHttpPost(request, "/GetBeanBagVoucherList");

      return VoucherGetUserVoucherResponse.fromJson(response);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  static Future<VoucherDeleteUserVoucherResponse> voucherDeleteUserVoucherApi(VoucherDeleteUserVoucherRequest request) async {
    try {
      var response = await CustomHttpClient.customHttpPost(request, "/DeleteBeanBagVoucherList");

      return VoucherDeleteUserVoucherResponse.fromJson(response);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  static Future<VoucherGetUserCouponResponse> voucherGetUserCouponApi(VoucherGetUserCouponRequest request) async {
    try {
      var response = await CustomHttpClient.customHttpPost(request, "/GetMyCouponList");

      return VoucherGetUserCouponResponse.fromJson(response);
    } catch (e) {
      print(e);
      throw e;
    }
  }
}

class VoucherDownloadRequest {
  int voucherID;
  int userID;
  String grabMethod;

  VoucherDownloadRequest(this.voucherID, this.userID, this.grabMethod);

  Map<String, dynamic> toJson() => {
        "ID": voucherID,
        "UserID": userID,
        "GrabMethod": grabMethod,
      };
}

class VoucherDownloadResponse {
  bool isSuccess;
  String error;

  VoucherDownloadResponse({this.isSuccess, this.error});

  factory VoucherDownloadResponse.fromJson(Map<String, dynamic> parsedJson) {
    return VoucherDownloadResponse(
      isSuccess: parsedJson['isSuccess'],
      error: parsedJson['Error'],
    );
  }
}

class VoucherAvailableResponse {
  List<VoucherDesignModel> voucherItems;
  List<VoucherDesignModel> couponItems;
  String error;

  VoucherAvailableResponse({this.voucherItems, this.couponItems, this.error});

  factory VoucherAvailableResponse.fromJson(Map<String, dynamic> parsedJson) {
    return VoucherAvailableResponse(
      voucherItems: (parsedJson['VoucherList'] as List).map((i) => VoucherDesignModel.fromJson(i)).toList(),
      couponItems: (parsedJson['CouponList'] as List).map((i) => VoucherDesignModel.fromJson(i)).toList(),
      error: parsedJson['Error'],
    );
  }
}

class VoucherAvailableAllRequest {
  String designType;

  VoucherAvailableAllRequest(this.designType);

  Map<String, dynamic> toJson() => {
        "designType": designType,
      };
}

class VoucherAvailableAllResponse {
  List<VoucherDesignModel> voucherItems;
  List<VoucherDesignModel> couponItems;
  String error;

  VoucherAvailableAllResponse({this.voucherItems, this.couponItems, this.error});

  factory VoucherAvailableAllResponse.fromJson(Map<String, dynamic> parsedJson) {
    return VoucherAvailableAllResponse(
      voucherItems: (parsedJson['VoucherList'] as List).map((i) => VoucherDesignModel.fromJson(i)).toList(),
      couponItems: (parsedJson['CouponList'] as List).map((i) => VoucherDesignModel.fromJson(i)).toList(),
      error: parsedJson['Error'],
    );
  }
}

class VoucherDetailsRequest {
  int voucherDesignID;
  int voucherID;

  VoucherDetailsRequest(this.voucherDesignID, this.voucherID);

  Map<String, dynamic> toJson() => {"ID": voucherDesignID, "VoucherID": voucherID};
}

class VoucherDetailsResponse {
  int voucherDesignID;
  String voucherDesignName;
  String voucherDesignUrl;
  Uint8List voucherDesignImageBytes;
  String voucherDesignValidUntilDate;
  List<String> voucherDesignTnCs;
  String error;

  VoucherDetailsResponse({this.voucherDesignID, this.voucherDesignName, this.voucherDesignUrl, this.voucherDesignImageBytes, this.voucherDesignValidUntilDate, this.voucherDesignTnCs, this.error});

  factory VoucherDetailsResponse.fromJson(Map<String, dynamic> parsedJson) {
    return VoucherDetailsResponse(
      voucherDesignID: parsedJson['ID'],
      voucherDesignName: parsedJson['Name'],
      voucherDesignUrl: parsedJson['url'],
      voucherDesignImageBytes: base64.decode(parsedJson['Image'] == null ? null : parsedJson['Image']),
      voucherDesignValidUntilDate: parsedJson['ValidTill'],
      voucherDesignTnCs: List<String>.from(parsedJson['TnCList']),
      error: parsedJson['Error'],
    );
  }
}

class VoucherGetUserVoucherRequest {
  int userID;
  String searchName;

  VoucherGetUserVoucherRequest(this.userID, this.searchName);

  Map<String, dynamic> toJson() => {
        "UserId": userID,
        "SearchName": searchName,
      };
}

class VoucherGetUserVoucherResponse {
  List<VoucherModel> voucherItems;
  String error;

  VoucherGetUserVoucherResponse({this.voucherItems, this.error});

  factory VoucherGetUserVoucherResponse.fromJson(Map<String, dynamic> parsedJson) {
    return VoucherGetUserVoucherResponse(
      voucherItems: (parsedJson['ConsumerVoucherList'] as List).map((i) => VoucherModel.fromJson(i)).toList(),
      error: parsedJson['Error'],
    );
  }
}

class VoucherDeleteUserVoucherRequest {
  int voucherID;
  int userID;

  VoucherDeleteUserVoucherRequest(this.voucherID, this.userID);

  Map<String, dynamic> toJson() => {
        "ID": voucherID,
        "UserId": userID,
      };
}

class VoucherDeleteUserVoucherResponse {
  String error;

  VoucherDeleteUserVoucherResponse({this.error});

  factory VoucherDeleteUserVoucherResponse.fromJson(Map<String, dynamic> parsedJson) {
    return VoucherDeleteUserVoucherResponse(
      error: parsedJson['Error'],
    );
  }
}

class VoucherGetUserCouponRequest {
  int userID;
  String searchName;

  VoucherGetUserCouponRequest(this.userID, this.searchName);

  Map<String, dynamic> toJson() => {
        "UserId": userID,
        "SearchName": searchName,
      };
}

class VoucherGetUserCouponResponse {
  List<CouponModel> couponItems;
  String error;

  VoucherGetUserCouponResponse({this.couponItems, this.error});

  factory VoucherGetUserCouponResponse.fromJson(Map<String, dynamic> parsedJson) {
    return VoucherGetUserCouponResponse(
      couponItems: (parsedJson['MyCouponList'] as List).map((i) => CouponModel.fromJson(i)).toList(),
      error: parsedJson['Error'],
    );
  }
}
