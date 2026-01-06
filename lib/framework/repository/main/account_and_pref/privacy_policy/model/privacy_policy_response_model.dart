// To parse this JSON data, do
//
//     final privacyPolicyResponseModel = privacyPolicyResponseModelFromJson(jsonString);

import 'dart:convert';

PrivacyPolicyResponseModel privacyPolicyResponseModelFromJson(String str) =>
    PrivacyPolicyResponseModel.fromJson(json.decode(str));

String privacyPolicyResponseModelToJson(PrivacyPolicyResponseModel data) =>
    json.encode(data.toJson());

class PrivacyPolicyResponseModel {
  Error? error;
  PrivacyPolicyData? data;
  int? code;
  String? message;
  bool? success;

  PrivacyPolicyResponseModel({
    this.error,
    this.data,
    this.code,
    this.message,
    this.success,
  });

  factory PrivacyPolicyResponseModel.fromJson(Map<String, dynamic> json) =>
      PrivacyPolicyResponseModel(
        error: json["error"] == null ? null : Error.fromJson(json["error"]),
        data: json["data"] == null
            ? null
            : PrivacyPolicyData.fromJson(json["data"]),
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

class PrivacyPolicyData {
  List<Result>? results;
  int? page;
  int? limit;
  int? totalPages;
  int? totalResults;

  PrivacyPolicyData({
    this.results,
    this.page,
    this.limit,
    this.totalPages,
    this.totalResults,
  });

  factory PrivacyPolicyData.fromJson(Map<String, dynamic> json) =>
      PrivacyPolicyData(
        results: json["results"] == null
            ? []
            : List<Result>.from(
                json["results"]!.map((x) => Result.fromJson(x))),
        page: json["page"],
        limit: json["limit"],
        totalPages: json["totalPages"],
        totalResults: json["totalResults"],
      );

  Map<String, dynamic> toJson() => {
        "results": results == null
            ? []
            : List<dynamic>.from(results!.map((x) => x.toJson())),
        "page": page,
        "limit": limit,
        "totalPages": totalPages,
        "totalResults": totalResults,
      };
}

class Result {
  String? description;
  bool? isActive;
  String? id;

  Result({
    this.description,
    this.isActive,
    this.id,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        description: json["description"],
        isActive: json["isActive"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "description": description,
        "isActive": isActive,
        "id": id,
      };
}

class Error {
  Error();

  factory Error.fromJson(Map<String, dynamic> json) => Error();

  Map<String, dynamic> toJson() => {};
}
