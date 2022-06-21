import 'package:shared_preferences/shared_preferences.dart';

import './../enums/generic_enums.dart';

class CustomSharedPreferences {
  static Future<bool> setValue(StorageEnum storageEnum, String value) async {
    var prefs = await SharedPreferences.getInstance();

    return await prefs.setString(storageEnum.toString(), value);
  }

  static Future<String> getValue(StorageEnum storageEnum) async {
    var prefs = await SharedPreferences.getInstance();

    var value = prefs.getString(storageEnum.toString());

    return value;
  }

  static Future<bool> removeAll() async {
    var prefs = await SharedPreferences.getInstance();

    return prefs.clear();
  }
}
