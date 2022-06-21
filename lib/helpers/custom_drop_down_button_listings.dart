import 'package:flutter/foundation.dart';

import '../enums/generic_enums.dart';
import './../apis/generic_apis.dart';
import './../enums/generic_enums.dart';
import './../helpers/extension_functions.dart';

class CustomDropDownButtonListing {
  static Future<List<ListingItem>> gender() async {
    return <ListingItem>[
      ListingItem(stringValue: describeEnum(GenderEnum.male).capitalize(), text: "Male"),
      ListingItem(stringValue: describeEnum(GenderEnum.female).capitalize(), text: "Female"),
    ];
  }

  static Future<List<ListingItem>> state(int countryID) async {
    var stateListingRequest = StateListingRequest(countryID.toString());
    var stateListingResponse = await GenericApis.stateListingApi(stateListingRequest);

    return stateListingResponse.items;
  }

  static Future<List<ListingItem>> country() async {
    var countryListingResponse = await GenericApis.countryListingApi();

    return countryListingResponse.items;
  }

  static List<ListingItem> voucherSorting() {
    return <ListingItem>[
      ListingItem(
          stringValue: describeEnum(VoucherSortByEnum.nationwide).capitalize(),
          text: describeEnum(VoucherSortByEnum.nationwide).capitalize()),
      ListingItem(
          stringValue: describeEnum(VoucherSortByEnum.local).capitalize(),
          text: describeEnum(VoucherSortByEnum.local).capitalize()),
    ];
  }
}
