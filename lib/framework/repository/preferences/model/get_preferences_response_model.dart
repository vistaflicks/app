// To parse this JSON data, do
//
//     final getPreferencesResponseModel = getPreferencesResponseModelFromJson(jsonString);

import 'dart:convert';

GetPreferencesResponseModel getPreferencesResponseModelFromJson(String str) =>
    GetPreferencesResponseModel.fromJson(json.decode(str));

String getPreferencesResponseModelToJson(GetPreferencesResponseModel data) =>
    json.encode(data.toJson());

class GetPreferencesResponseModel {
  Error? error;
  List<PreferenceResult>? data;
  int? code;
  String? message;
  bool? success;

  GetPreferencesResponseModel({
    this.error,
    this.data,
    this.code,
    this.message,
    this.success,
  });

  factory GetPreferencesResponseModel.fromJson(Map<String, dynamic> json) =>
      GetPreferencesResponseModel(
        error: json["error"] == null ? null : Error.fromJson(json["error"]),
        data: json["data"] == null
            ? []
            : List<PreferenceResult>.from(
                json["data"]!.map((x) => PreferenceResult.fromJson(x))),
        code: json["code"],
        message: json["message"],
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "error": error?.toJson(),
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "code": code,
        "message": message,
        "success": success,
      };
}

class PreferenceResult {
  String? id;
  String? name;
  dynamic icon;
  dynamic description;
  bool? isPreferred;
  dynamic maxImdbRating;
  dynamic minImdbRating;

  PreferenceResult({
    this.id,
    this.name,
    this.icon,
    this.description,
    this.isPreferred,
    this.maxImdbRating,
    this.minImdbRating,
  });

  factory PreferenceResult.fromJson(Map<String, dynamic> json) =>
      PreferenceResult(
        id: json["id"],
        name: json["name"],
        icon: json["icon"],
        description: json["description"],
        isPreferred: json["isPreferred"],
        maxImdbRating: json["maxImdbRating"],
        minImdbRating: json["minImdbRating"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "icon": icon,
        "description": description,
        "isPreferred": isPreferred,
        "maxImdbRating": maxImdbRating,
        "minImdbRating": minImdbRating,
      };
}

class Error {
  Error();

  factory Error.fromJson(Map<String, dynamic> json) => Error();

  Map<String, dynamic> toJson() => {};
}
