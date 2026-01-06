// To parse this JSON data, do
//
//     final getReviewModel = getReviewModelFromJson(jsonString);

import 'dart:convert';

GetReviewModel getReviewModelFromJson(String str) =>
    GetReviewModel.fromJson(json.decode(str));

String getReviewModelToJson(GetReviewModel data) => json.encode(data.toJson());

class GetReviewModel {
  Error? error;
  List<Datum>? data;
  int? code;
  String? message;
  bool? success;

  GetReviewModel({
    this.error,
    this.data,
    this.code,
    this.message,
    this.success,
  });

  factory GetReviewModel.fromJson(Map<String, dynamic> json) => GetReviewModel(
        error: json["error"] == null ? null : Error.fromJson(json["error"]),
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
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

class Datum {
  String? id;
  double? duration;
  String? thumbnailUrl;

  Datum({
    this.id,
    this.duration,
    this.thumbnailUrl,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        duration: json["duration"]?.toDouble(),
        thumbnailUrl: json["thumbnailUrl"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "duration": duration,
        "thumbnailUrl": thumbnailUrl,
      };
}

class Error {
  Error();

  factory Error.fromJson(Map<String, dynamic> json) => Error();

  Map<String, dynamic> toJson() => {};
}
