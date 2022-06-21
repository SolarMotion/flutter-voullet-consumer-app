import './../helpers/custom_http_clients.dart';
import './../models/voucher_design_models.dart';

class HighlightApis {
  static Future<HighlightResponse> highlightApi() async {
    var response = await CustomHttpClient.customHttpPostNoRequest("/getHighlight");

    return HighlightResponse.fromJson(response);
  }
}

class HighlightResponse {
  String error;
  List<VoucherDesignModel> popularItems;
  List<VoucherDesignModel> newItems;

  HighlightResponse({this.error, this.popularItems, this.newItems});

  factory HighlightResponse.fromJson(Map<String, dynamic> parsedJson) {
    return HighlightResponse(
      error: parsedJson['Error'],
      popularItems: (parsedJson['popularItemList'] as List).map((i) => VoucherDesignModel.fromJson(i)).toList(),
      newItems: (parsedJson['newItemList'] as List).map((i) => VoucherDesignModel.fromJson(i)).toList(),
    );
  }
}
