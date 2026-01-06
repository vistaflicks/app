// To parse this JSON data, do
//
//     final commonResponseModel = commonResponseModelFromJson(jsonString);

// import 'dart:convert';
//
// CommonResponseModel commonResponseModelFromJson(String str) => CommonResponseModel.fromJson(json.decode(str));
//
// String commonResponseModelToJson(CommonResponseModel data) => json.encode(data.toJson());
//
// class CommonResponseModel {
//   bool? success;
//   String? message;
//   int? status;
//
//   CommonResponseModel({
//     this.success,
//     this.message,
//     this.status,
//   });
//
//   factory CommonResponseModel.fromJson(Map<String, dynamic> json) => CommonResponseModel(
//         success: json['success'],
//         message: json['message'],
//         status: json['status'],
//       );
//
//   Map<String, dynamic> toJson() => {
//         'success': success,
//         'message': message,
//         'status': status,
//       };
// }

import 'dart:convert';

CommonResponseModel commonResponseModelFromJson(String str) =>
    CommonResponseModel.fromJson(json.decode(str));

String commonResponseModelToJson(CommonResponseModel data) =>
    json.encode(data.toJson());

class CommonResponseModel {
  Error? error;
  bool? success;
  String? message;
  int? status;

  CommonResponseModel({
    this.error,
    this.success,
    this.message,
    this.status,
  });

  factory CommonResponseModel.fromJson(Map<String, dynamic> json) =>
      CommonResponseModel(
        error: json["error"] == null ? null : Error.fromJson(json["error"]),
        success: json['success'],
        message: json['message'],
        status: json['status'],
      );

  Map<String, dynamic> toJson() => {
        "error": error?.toJson(),
        'success': success,
        'message': message,
        'status': status,
      };
}

class Error {
  Error();

  factory Error.fromJson(Map<String, dynamic> json) => Error();

  Map<String, dynamic> toJson() => {};
}
