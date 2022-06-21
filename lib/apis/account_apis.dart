import "./../helpers/custom_http_clients.dart";

class AccountApis {
  static Future<ValidateUserResponse> validateUserApi(ValidateUserRequest request) async {
    var response = await CustomHttpClient.customHttpPost(request, "/ValidateUser");

    return ValidateUserResponse.fromJson(response);
  }

  static Future<ForgotPasswordResponse> forgotPasswordApi(ForgotPasswordRequest request) async {
    var response = await CustomHttpClient.customHttpPost(request, "/ForgotPassword");

    return ForgotPasswordResponse.fromJson(response);
  }

  static Future<RegistrationResponse> registrationApi(RegistrationRequest request) async {
    var response = await CustomHttpClient.customHttpPost(request, "/CreateAccount");

    return RegistrationResponse.fromJson(response);
  }

  static Future<UserDetailsResponse> userDetailsApi(UserDetailsRequest request) async {
    var response = await CustomHttpClient.customHttpPost(request, "/GetUserDetail");

    return UserDetailsResponse.fromJson(response);
  }

  static Future<UpdateProfilePictureResponse> updateProfilePictureApi(UpdateProfilePictureRequest request) async {
    var response = await CustomHttpClient.customHttpPost(request, "/UpdateProfilePicture");

    return UpdateProfilePictureResponse.fromJson(response);
  }

  static Future<ChangePasswordResponse> changePasswordApi(ChangePasswordRequest request) async {
    var response = await CustomHttpClient.customHttpPost(request, "/UpdateLoginInformation");

    return ChangePasswordResponse.fromJson(response);
  }

    static Future<UpdateUserDetailsResponse> updateUserDetailsApi(UpdateUserDetailsRequest request) async {
    var response = await CustomHttpClient.customHttpPost(request, "/UpdateUserDetail");

    return UpdateUserDetailsResponse.fromJson(response);
  }
}

class ValidateUserRequest {
  String email;
  String password;
  String verificationCode;

  ValidateUserRequest(this.email, this.password, this.verificationCode);

  Map<String, dynamic> toJson() => {
        "Username": email,
        "Password": password,
        "VerificationCode": verificationCode,
      };
}

class ValidateUserResponse {
  int userID;
  String name;
  bool isValid;
  bool isFirstLogin;
  String error;

  ValidateUserResponse({this.userID, this.name, this.isValid, this.isFirstLogin, this.error});

  factory ValidateUserResponse.fromJson(Map<String, dynamic> parsedJson) {
    return ValidateUserResponse(
        userID: parsedJson['UserId'],
        name: parsedJson['Name'],
        isValid: parsedJson['Valid'],
        isFirstLogin: parsedJson['IsFirstLogin'],
        error: parsedJson['Error']);
  }
}

class ForgotPasswordRequest {
  String email;

  ForgotPasswordRequest(this.email);

  Map<String, dynamic> toJson() => {
        "Username": email,
      };
}

class ForgotPasswordResponse {
  bool isValid;
  String error;

  ForgotPasswordResponse({this.isValid, this.error});

  factory ForgotPasswordResponse.fromJson(Map<String, dynamic> parsedJson) {
    return ForgotPasswordResponse(isValid: parsedJson['Success'], error: parsedJson['Error']);
  }
}

class RegistrationRequest {
  String username;
  String password;
  String name;
  String email;
  String mobileNo;
  String birthday;
  String gender;
  String idNo;
  String address1;
  String address2;
  String address3;
  String postcode;
  String townCity;
  int stateID;

  RegistrationRequest(
    this.username,
    this.password,
    this.name,
    this.email,
    this.mobileNo,
    this.birthday,
    this.gender,
    this.idNo,
    this.address1,
    this.address2,
    this.address3,
    this.postcode,
    this.townCity,
    this.stateID,
  );

  Map<String, dynamic> toJson() => {
        "Username": username,
        "Password": password,
        "Name": name,
        "Email": email,
        "Mobile": mobileNo,
        "Birthday": birthday,
        "Gender": gender,
        "IDNo": idNo,
        "Address1": address1,
        "Address2": address2,
        "Address3": address3,
        "Postcode": postcode,
        "TownCity": townCity,
        "StateID": stateID,
      };
}

class RegistrationResponse {
  int userID;
  String error;

  RegistrationResponse({this.userID, this.error});

  factory RegistrationResponse.fromJson(Map<String, dynamic> parsedJson) {
    return RegistrationResponse(userID: parsedJson['UserId'], error: parsedJson['Error']);
  }
}

class UserDetailsRequest {
  int userID;

  UserDetailsRequest(this.userID);

  Map<String, dynamic> toJson() => {
        "userID": userID,
      };
}

class UserDetailsResponse {
  int userID;
  int consumerID;
  String username;
  String name;
  String idNo;
  String birthday;
  String gender;
  String email;
  String mobileNo;
  String address1;
  String address2;
  String address3;
  String postcode;
  String townCity;
  int stateID;
  String stateName;
  String profileImageBase64;
  String error;

  UserDetailsResponse({
    this.userID,
    this.consumerID,
    this.username,
    this.name,
    this.idNo,
    this.birthday,
    this.gender,
    this.email,
    this.mobileNo,
    this.address1,
    this.address2,
    this.address3,
    this.postcode,
    this.townCity,
    this.stateID,
    this.stateName,
    this.profileImageBase64,
    this.error,
  });

  factory UserDetailsResponse.fromJson(Map<String, dynamic> parsedJson) {
    return UserDetailsResponse(
      userID: parsedJson['userID'],
      consumerID: parsedJson['ID'],
      username: parsedJson['LoginID'],
      name: parsedJson['Name'],
      idNo: parsedJson['NRIC'],
      birthday: parsedJson['DOB'],
      gender: parsedJson['Gender'],
      email: parsedJson['Email'],
      mobileNo: parsedJson['Mobile'],
      address1: parsedJson['Address1'],
      address2: parsedJson['Address2'],
      address3: parsedJson['Address3'],
      postcode: parsedJson['Postcode'],
      townCity: parsedJson['TownCity'],
      stateID: parsedJson['StateID'],
      stateName: parsedJson['StateName'],
      profileImageBase64: parsedJson['Image'],
      error: parsedJson['Error'],
    );
  }
}

class UpdateProfilePictureRequest {
  int userID;
  UpdateProfilePictureItem pictureDetails;

  UpdateProfilePictureRequest(this.userID, this.pictureDetails);

  Map<String, dynamic> toJson() => {
        "userID": userID,
        "UserDetail": pictureDetails.toJson(),
      };
}

class UpdateProfilePictureItem {
  String imageBase64;
  String imageType;

  UpdateProfilePictureItem(this.imageType, this.imageBase64);

  Map<String, dynamic> toJson() => {
        "Image": imageBase64,
        "Imagetype": imageType,
      };
}

class UpdateProfilePictureResponse {
  String error;

  UpdateProfilePictureResponse({
    this.error,
  });

  factory UpdateProfilePictureResponse.fromJson(Map<String, dynamic> parsedJson) {
    return UpdateProfilePictureResponse(
      error: parsedJson['Error'],
    );
  }
}

class ChangePasswordRequest {
  ChangePasswordItem changePasswordDetails;

  ChangePasswordRequest(this.changePasswordDetails);

  Map<String, dynamic> toJson() => {
        "UserDetail": changePasswordDetails.toJson(),
      };
}

class ChangePasswordItem {
  String email;
  String password;
  String newPassword;

  ChangePasswordItem(this.email, this.password, this.newPassword);

  Map<String, dynamic> toJson() => {
        "LoginID": email,
        "Password": password,
        "NewPassword": newPassword,
      };
}

class ChangePasswordResponse {
  String error;
  bool isWrongPassword;

  ChangePasswordResponse({
    this.error,
    this.isWrongPassword,
  });

  factory ChangePasswordResponse.fromJson(Map<String, dynamic> parsedJson) {
    return ChangePasswordResponse(
      error: parsedJson['Error'],
      isWrongPassword: parsedJson['WrongPassword'],
    );
  }
}

class UpdateUserDetailsRequest {
  int userID;
  UpdateUserDetailsItem updateUserDetails;

  UpdateUserDetailsRequest(this.userID, this.updateUserDetails);

  Map<String, dynamic> toJson() => {
        "userID": userID,
        "UserDetail": updateUserDetails,
      };
}

class UpdateUserDetailsItem {
  String name;
  String idNo;
  String birthday;
  String gender;
  String mobileNo;
  String address1;
  String address2;
  String address3;
  String postcode;
  String townCity;
  int stateID;

  UpdateUserDetailsItem(
    this.name,
    this.idNo,
    this.birthday,
    this.gender,
    this.mobileNo,
    this.address1,
    this.address2,
    this.address3,
    this.postcode,
    this.townCity,
    this.stateID,
  );

  Map<String, dynamic> toJson() => {
        "Name": name,
        "NRIC": idNo,
        "DOB": birthday,
        "Gender": gender,
        "Mobile": mobileNo,
        "Address1": address1,
        "Address2": address2,
        "Address3": address3,
        "Postcode": postcode,
        "TownCity": townCity,
        "StateID": stateID,
      };
}

class UpdateUserDetailsResponse {
  String error;

  UpdateUserDetailsResponse({
    this.error,
  });

  factory UpdateUserDetailsResponse.fromJson(Map<String, dynamic> parsedJson) {
    return UpdateUserDetailsResponse(
      error: parsedJson['Error'],
    );
  }
}
