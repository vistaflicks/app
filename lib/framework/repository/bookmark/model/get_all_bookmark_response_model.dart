// To parse this JSON data, do
//
//     final getAllBookmarkResponseModel = getAllBookmarkResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:vista_flicks/framework/repository/bookmark/model/get_bookmark_list_response_model.dart';

GetAllBookmarkResponseModel getAllBookmarkResponseModelFromJson(String str) => GetAllBookmarkResponseModel.fromJson(json.decode(str));

String getAllBookmarkResponseModelToJson(GetAllBookmarkResponseModel data) => json.encode(data.toJson());

class GetAllBookmarkResponseModel {
  Error? error;
  BookmarkData? data;
  int? code;
  String? message;
  bool? success;

  GetAllBookmarkResponseModel({
    this.error,
    this.data,
    this.code,
    this.message,
    this.success,
  });

  factory GetAllBookmarkResponseModel.fromJson(Map<String, dynamic> json) => GetAllBookmarkResponseModel(
        error: json["error"] == null ? null : Error.fromJson(json["error"]),
        data: json["data"] == null ? null : BookmarkData.fromJson(json["data"]),
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

class BookmarkData {
  List<BookmarkBanner>? results;
  int? page;
  int? limit;
  int? totalPages;
  int? totalResults;

  BookmarkData({
    this.results,
    this.page,
    this.limit,
    this.totalPages,
    this.totalResults,
  });

  factory BookmarkData.fromJson(Map<String, dynamic> json) => BookmarkData(
        results: json["results"] == null ? [] : List<BookmarkBanner>.from(json["results"]!.map((x) => BookmarkBanner.fromJson(x))),
        page: json["page"],
        limit: json["limit"],
        totalPages: json["totalPages"],
        totalResults: json["totalResults"],
      );

  Map<String, dynamic> toJson() => {
        "results": results == null ? [] : List<dynamic>.from(results!.map((x) => x.toJson())),
        "page": page,
        "limit": limit,
        "totalPages": totalPages,
        "totalResults": totalResults,
      };
}

class Error {
  Error();

  factory Error.fromJson(Map<String, dynamic> json) => Error();

  Map<String, dynamic> toJson() => {};
}
