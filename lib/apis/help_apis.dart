import 'dart:core';

import './../helpers/custom_http_clients.dart';

class HelpApis {
  static Future<FeedbackFormResponse> feedbackFormApi(FeedbackFormRequest request) async {
    var response = await CustomHttpClient.customHttpPost(request, "/SendFeedback");

    return FeedbackFormResponse.fromJson(response);
  }
}

class FeedbackFormRequest {
  String name;
  String email;
  String contactNo;
  String subject;
  String description;
  String type;
  List<String> imageBase64List;

  FeedbackFormRequest(
    this.name,
    this.email,
    this.contactNo,
    this.subject,
    this.description,
    this.type,
    this.imageBase64List,
  );

  Map<String, dynamic> toJson() => {
        "Name": name,
        "Email": email,
        "ContactNo": contactNo,
        "Subject": subject,
        "Description": description,
        "Type": type,
        "ImageList": imageBase64List,
      };
}

class FeedbackFormResponse {
  String error;
  int waitingDuration;

  FeedbackFormResponse({this.error, this.waitingDuration});

  factory FeedbackFormResponse.fromJson(Map<String, dynamic> parsedJson) {
    return FeedbackFormResponse(
      error: parsedJson['Error'],
      waitingDuration: parsedJson['WaitingDuration'],
    );
  }
}
