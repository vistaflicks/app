// To parse this JSON data, do
//
//     final getSimilarModel = getSimilarModelFromJson(jsonString);

import 'dart:convert';

GetSimilarModel getSimilarModelFromJson(String str) =>
    GetSimilarModel.fromJson(json.decode(str));

String getSimilarModelToJson(GetSimilarModel data) =>
    json.encode(data.toJson());

class GetSimilarModel {
  Error? error;
  List<Datum>? data;
  int? code;
  String? message;
  bool? success;

  GetSimilarModel({
    this.error,
    this.data,
    this.code,
    this.message,
    this.success,
  });

  factory GetSimilarModel.fromJson(Map<String, dynamic> json) =>
      GetSimilarModel(
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
  String? title;
  String? imageUrl;

  Datum({
    this.id,
    this.title,
    this.imageUrl,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        title: json["title"],
        imageUrl: json["imageUrl"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "imageUrl": imageUrl,
      };
}

class Error {
  Error();

  factory Error.fromJson(Map<String, dynamic> json) => Error();

  Map<String, dynamic> toJson() => {};
}
