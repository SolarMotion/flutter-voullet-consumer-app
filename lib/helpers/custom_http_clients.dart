import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

import './../enums/generic_enums.dart';
import './custom_shared_preferences.dart';
import './extension_functions.dart';

class CustomHttpClient {
  static const String _baseUrl = "http://charitymobileservice.azurewebsites.net";
  static const String _subDirectory = "/consumerservice.svc";
  static const String _secretKey = "Gk8OlaAj14";
  static const List<int> _successCodes = [200, 201];

  static Future<dynamic> customHttpPost(Object object, String action) async {
    try {
      var _requestHeaders = await _constructRequestHeader();

      var _requestObject = {};
      _requestObject["request"] = object;
      var _jsonRequest = json.encode(_requestObject);

      final http.Response response = await http.post(
        "$_baseUrl$_subDirectory$action",
        headers: _requestHeaders,
        body: _jsonRequest,
      );

      if (_successCodes.contains(response.statusCode)) {
        return json.decode(response.body);
      } else {
        throw Exception("Failed to load api with invalid HTTP status code: ${response.statusCode}");
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  static Future<dynamic> customHttpPostNoRequest(String action) async {
    try {
      var _requestHeaders = await _constructRequestHeader();

      final http.Response response = await http.post(
        "$_baseUrl$_subDirectory$action",
        headers: _requestHeaders,
      );

      if (_successCodes.contains(response.statusCode)) {
        return json.decode(response.body);
      } else {
        throw Exception("Failed to load api with invalid HTTP status code.");
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  static Future<dynamic> customHttpPostNoRequestObject(Object object, String action) async {
    try {
      var _requestHeaders = await _constructRequestHeader();

      var _jsonRequest = json.encode(object);

      final http.Response response = await http.post(
        "$_baseUrl$_subDirectory$action",
        headers: _requestHeaders,
        body: _jsonRequest,
      );

      if (_successCodes.contains(response.statusCode)) {
        return json.decode(response.body);
      } else {
        throw Exception("Failed to load api with invalid HTTP status code.");
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  static String _unixTimeStamp() {
    var unixEpoch = new DateTime(1970, 1, 1).millisecond;
    var currentEpoch = new DateTime.now().millisecondsSinceEpoch;
    return (currentEpoch - unixEpoch).toString();
  }

  static String _hashedToken(String message, String secretKey) {
    var messageBytes = ascii.encode(message);
    var secretKeyBytes = ascii.encode(secretKey);

    Hmac hmac = new Hmac(sha256, secretKeyBytes);
    Digest digest = hmac.convert(messageBytes);

    String base64Mac = base64.encode(digest.bytes);

    return base64Mac;
  }

  static Future<Map<String, String>> _constructRequestHeader() async {
    var unixTimeStamp = _unixTimeStamp();
    var userID = await CustomSharedPreferences.getValue(StorageEnum.userID);
    var intUserID = userID.toInt();
    var hashedToken = _hashedToken("$intUserID$unixTimeStamp", _secretKey);

    Map<String, String> _requestHeaders = {"Content-Type": "application/json", "DeviceId": "$intUserID", "TimeStamp": "$unixTimeStamp", "HashInput": "$hashedToken"};

    return _requestHeaders;
  }
}
