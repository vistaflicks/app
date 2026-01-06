// To parse this JSON data, do
//
//     final checkExistingUserResponseModel = checkExistingUserResponseModelFromJson(jsonString);

import 'dart:convert';

CheckExistingUserResponseModel checkExistingUserResponseModelFromJson(
        String str) =>
    CheckExistingUserResponseModel.fromJson(json.decode(str));

String checkExistingUserResponseModelToJson(
        CheckExistingUserResponseModel data) =>
    json.encode(data.toJson());

class CheckExistingUserResponseModel {
  Error? error;
  Data? data;
  int? code;
  String? message;
  bool? success;

  CheckExistingUserResponseModel({
    this.error,
    this.data,
    this.code,
    this.message,
    this.success,
  });

  factory CheckExistingUserResponseModel.fromJson(Map<String, dynamic> json) =>
      CheckExistingUserResponseModel(
        error: json["error"] == null ? null : Error.fromJson(json["error"]),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        code: json["code"],
        message: json["message"],
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "error": error?.toJson(),
        "data": data?.toJson(),
        "code": code,
        "message": message,
        "success": success,
      };
}

class Data {
  bool? isNewUser;

  Data({
    this.isNewUser,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        isNewUser: json["isNewUser"],
      );

  Map<String, dynamic> toJson() => {
        "isNewUser": isNewUser,
      };
}

class Error {
  Error();

  factory Error.fromJson(Map<String, dynamic> json) => Error();

  Map<String, dynamic> toJson() => {};
}
