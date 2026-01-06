// To parse this JSON data, do
//
//     final errorResponse = errorResponseFromJson(jsonString);

import 'dart:convert';

ErrorResponse errorResponseFromJson(String str) => ErrorResponse.fromJson(json.decode(str));

String errorResponseToJson(ErrorResponse data) => json.encode(data.toJson());

class ErrorResponse {
  String? errorCode;
  String? errorDescription;

  ErrorResponse({
    this.errorCode,
    this.errorDescription,
  });

  factory ErrorResponse.fromJson(Map<String, dynamic> json) => ErrorResponse(
        errorCode: json['errorCode'],
        errorDescription: json['errorDescription'],
      );

  Map<String, dynamic> toJson() => {
        'errorCode': errorCode,
        'errorDescription': errorDescription,
      };
}
