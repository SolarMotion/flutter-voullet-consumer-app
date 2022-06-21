import 'dart:convert';
import 'dart:typed_data';

class VoucherModel {
  int voucherID;
  int voucherDesignID;
  String voucherDesignName;
  String voucherDesignDescription;
  Uint8List voucherDesignImageBytes;
  String voucherDesignUrl;
  String voucherDesignTypeCode;
  String validUntilDate;

  VoucherModel({
    this.voucherID,
    this.voucherDesignID,
    this.voucherDesignName,
    this.voucherDesignDescription,
    this.voucherDesignImageBytes,
    this.voucherDesignUrl,
    this.voucherDesignTypeCode,
    this.validUntilDate,
  });

  factory VoucherModel.fromJson(Map<String, dynamic> parsedJson) {
    return VoucherModel(
      voucherID: parsedJson['ID'],
      voucherDesignID: parsedJson['VoucherDesignID'],
      voucherDesignName: parsedJson['VoucherName'],
      voucherDesignDescription: parsedJson['VoucherDescription'],
      voucherDesignImageBytes:
          base64.decode(parsedJson['VoucherLogoStr'] == null ? null : parsedJson['VoucherLogoStr']),
      voucherDesignUrl: parsedJson['Url'],
      voucherDesignTypeCode: parsedJson['DesignTypeCode'],
      validUntilDate: parsedJson['VoucherValidUntilStr'],
    );
  }
}

class CouponModel {
  int voucherID;
  int voucherDesignID;
  String voucherDesignName;
  String voucherDesignDescription;
  Uint8List voucherDesignImageBytes;
  String voucherDesignUrl;
  String voucherDesignTypeCode;
  String validUntilDate;
  String voucherCountryName;

  CouponModel({
    this.voucherID,
    this.voucherDesignID,
    this.voucherDesignName,
    this.voucherDesignDescription,
    this.voucherDesignImageBytes,
    this.voucherDesignUrl,
    this.voucherDesignTypeCode,
    this.validUntilDate,
    this.voucherCountryName,
  });

  factory CouponModel.fromJson(Map<String, dynamic> parsedJson) {
    return CouponModel(
      voucherID: parsedJson['ID'],
      voucherDesignID: parsedJson['VoucherDesignID'],
      voucherDesignName: parsedJson['Name'],
      voucherDesignDescription: parsedJson['Description'],
      voucherDesignImageBytes: base64.decode(parsedJson['LogoStr'] == null ? null : parsedJson['LogoStr']),
      voucherDesignUrl: parsedJson['Url'],
      voucherDesignTypeCode: parsedJson['DesignTypeCode'],
      validUntilDate: parsedJson['ValidUntilStr'],
      voucherCountryName: parsedJson['CountryName'],
    );
  }
}
