import 'dart:convert';
import 'dart:typed_data';

class VoucherDesignModel {
  int voucherDesignID;
  String voucherDesignName;
  String voucherDesignDescription;
  Uint8List voucherDesignImageBytes;
  String voucherDesignUrl;
  String voucherDesignTypeCode;

  int orgID;
  String orgName;
  String validUntilDate;
  String validUntilDate2;

  VoucherDesignModel({
    this.voucherDesignID,
    this.voucherDesignName,
    this.voucherDesignDescription,
    this.voucherDesignImageBytes,
    this.voucherDesignUrl,
    this.voucherDesignTypeCode,
    this.orgID,
    this.orgName,
    this.validUntilDate,
    this.validUntilDate2,
  });

  factory VoucherDesignModel.fromJson(Map<String, dynamic> parsedJson) {
    return VoucherDesignModel(
      voucherDesignID: parsedJson['VoucherID'],
      voucherDesignName: parsedJson['VoucherName'],
      voucherDesignDescription: parsedJson['VoucherDescription'],
      voucherDesignImageBytes:
          base64.decode(parsedJson['VoucherLogoStr'] == null ? null : parsedJson['VoucherLogoStr']),
      voucherDesignUrl: parsedJson['url'],
      voucherDesignTypeCode: parsedJson['DesignTypeCode'],
      orgID: parsedJson['OrgID'],
      orgName: parsedJson['OrgName'],
      validUntilDate: parsedJson['ValidUntilStr'],
      validUntilDate2: parsedJson['VoucherValidUntilStr'],
    );
  }
}
