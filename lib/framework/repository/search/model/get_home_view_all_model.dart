// To parse this JSON data, do
//
//     final getHomeViewAllModel = getHomeViewAllModelFromJson(jsonString);

import 'dart:convert';

GetHomeViewAllModel getHomeViewAllModelFromJson(String str) =>
    GetHomeViewAllModel.fromJson(json.decode(str));

String getHomeViewAllModelToJson(GetHomeViewAllModel data) =>
    json.encode(data.toJson());

class GetHomeViewAllModel {
  Error? error;
  Data? data;
  int? code;
  String? message;
  bool? success;

  GetHomeViewAllModel({
    this.error,
    this.data,
    this.code,
    this.message,
    this.success,
  });

  factory GetHomeViewAllModel.fromJson(Map<String, dynamic> json) =>
      GetHomeViewAllModel(
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
  List<HomeViewAllData>? results;
  int? page;
  int? limit;
  int? totalPages;
  int? totalResults;

  Data({
    this.results,
    this.page,
    this.limit,
    this.totalPages,
    this.totalResults,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        results: json["results"] == null
            ? []
            : List<HomeViewAllData>.from(
                json["results"]!.map((x) => HomeViewAllData.fromJson(x))),
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

class HomeViewAllData {
  String? name;
  String? imageUrl;
  String? contentId;

  HomeViewAllData({
    this.name,
    this.imageUrl,
    this.contentId,
  });

  factory HomeViewAllData.fromJson(Map<String, dynamic> json) =>
      HomeViewAllData(
        name: json["name"],
        imageUrl: json["imageUrl"],
        contentId: json["contentId"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "imageUrl": imageUrl,
        "contentId": contentId,
      };
}

class Error {
  Error();

  factory Error.fromJson(Map<String, dynamic> json) => Error();

  Map<String, dynamic> toJson() => {};
}
