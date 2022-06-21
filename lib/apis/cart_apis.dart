import 'dart:convert';
import 'dart:typed_data';

import './../helpers/custom_http_clients.dart';

class CartApis {
  static Future<CartAddResponse> addApi(CartAddRequest request) async {
    var response = await CustomHttpClient.customHttpPost(request, "/AddCart");

    return CartAddResponse.fromJson(response);
  }

  static Future<CartToggleResponse> toggleApi(CartToggleRequest request) async {
    var response = await CustomHttpClient.customHttpPost(request, "/UpdateToggle");

    return CartToggleResponse.fromJson(response);
  }

  static Future<CartGetResponse> getApi(CartGetRequest request) async {
    try {
      var response = await CustomHttpClient.customHttpPost(request, "/GetCart");

      return CartGetResponse.fromJson(response);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  static Future<CartRemoveResponse> removeApi(CartRemoveRequest request) async {
    var response = await CustomHttpClient.customHttpPost(request, "/RemoveCart");

    return CartRemoveResponse.fromJson(response);
  }

  static Future<String> paymentApi(CartPaymentRequest request) async {
    var response = await CustomHttpClient.customHttpPost(request, "/DummyPayment");

    return response;
  }
}

class CartAddRequest {
  int voucherDesignID;
  int userID;

  CartAddRequest(this.voucherDesignID, this.userID);

  Map<String, dynamic> toJson() => {
        "VoucherDesignID": voucherDesignID,
        "UserID": userID,
      };
}

class CartAddResponse {
  String error;

  CartAddResponse({this.error});

  factory CartAddResponse.fromJson(Map<String, dynamic> parsedJson) {
    return CartAddResponse(
      error: parsedJson['Error'],
    );
  }
}

class CartToggleRequest {
  int voucherDesignID;
  bool isOne;
  bool isAll;
  int userID;

  CartToggleRequest(this.voucherDesignID, this.isOne, this.isAll, this.userID);

  Map<String, dynamic> toJson() => {
        "VoucherDesignID": voucherDesignID,
        "isOne": isOne,
        "isAll": isAll,
        "UserID": userID,
      };
}

class CartToggleResponse {
  int voucherDesignID;
  bool isOne;
  bool isAll;
  int userID;
  String error;

  CartToggleResponse({this.voucherDesignID, this.isOne, this.isAll, this.userID, this.error});

  factory CartToggleResponse.fromJson(Map<String, dynamic> parsedJson) {
    return CartToggleResponse(
      voucherDesignID: parsedJson['VoucherDesignID'],
      isOne: parsedJson['isOne'],
      isAll: parsedJson['isAll'],
      userID: parsedJson['UserID'],
      error: parsedJson['Error'],
    );
  }
}

class CartGetRequest {
  int userID;

  CartGetRequest(this.userID);

  Map<String, dynamic> toJson() => {
        "UserID": userID,
      };
}

class CartGetResponse {
  List<CartVoucherDesignItem> cartVoucherDesignItems;
  String error;

  CartGetResponse({this.cartVoucherDesignItems, this.error});

  factory CartGetResponse.fromJson(Map<String, dynamic> parsedJson) {
    return CartGetResponse(
      cartVoucherDesignItems:
          (parsedJson['CartVoucherList'] as List).map((i) => CartVoucherDesignItem.fromJson(i)).toList(),
      error: parsedJson['Error'],
    );
  }
}

class CartVoucherDesignItem {
  int cartID;
  int voucherDesignID;
  String voucherDesignName;
  String voucherDescription;
  double voucherDesignPrice;
  Uint8List voucherDesignImageBytes;
  bool isSelected;

  CartVoucherDesignItem(
      {this.cartID,
      this.voucherDesignID,
      this.voucherDesignName,
      this.voucherDescription,
      this.voucherDesignPrice,
      this.voucherDesignImageBytes,
      this.isSelected});

  factory CartVoucherDesignItem.fromJson(Map<String, dynamic> parsedJson) {
    return CartVoucherDesignItem(
      cartID: parsedJson['ID'],
      voucherDesignID: parsedJson['VoucherDesignID'],
      voucherDesignName: parsedJson['VoucherName'],
      voucherDescription: parsedJson['VoucherDescription'],
      voucherDesignPrice: parsedJson['VoucherPrice'],
      voucherDesignImageBytes:
          base64.decode(parsedJson['VoucherLogoStr'] == null ? null : parsedJson['VoucherLogoStr']),
      isSelected: parsedJson['Selected'],
    );
  }
}

class CartRemoveRequest {
  int userID;

  CartRemoveRequest(this.userID);

  Map<String, dynamic> toJson() => {
        "UserID": userID,
      };
}

class CartRemoveResponse {
  String error;

  CartRemoveResponse({this.error});

  factory CartRemoveResponse.fromJson(Map<String, dynamic> parsedJson) {
    return CartRemoveResponse(
      error: parsedJson['Error'],
    );
  }
}

class CartPaymentRequest {
  int userID;

  CartPaymentRequest(this.userID);

  Map<String, dynamic> toJson() => {
        "UserID": userID,
      };
}
