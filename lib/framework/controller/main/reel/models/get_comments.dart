// To parse this JSON data, do
//
//     final getCommentsResponseModel = getCommentsResponseModelFromJson(jsonString);

import 'dart:convert';

GetCommentsResponseModel getCommentsResponseModelFromJson(String str) =>
    GetCommentsResponseModel.fromJson(json.decode(str));

String getCommentsResponseModelToJson(GetCommentsResponseModel data) =>
    json.encode(data.toJson());

class GetCommentsResponseModel {
  Error? error;
  GetCommentData? data;
  int? code;
  String? message;
  bool? success;

  GetCommentsResponseModel({
    this.error,
    this.data,
    this.code,
    this.message,
    this.success,
  });

  factory GetCommentsResponseModel.fromJson(Map<String, dynamic> json) =>
      GetCommentsResponseModel(
        error: json["error"] == null ? null : Error.fromJson(json["error"]),
        data:
            json["data"] == null ? null : GetCommentData.fromJson(json["data"]),
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

class GetCommentData {
  List<Result>? results;
  int? page;
  int? limit;
  int? totalPages;
  int? totalResults;

  GetCommentData({
    this.results,
    this.page,
    this.limit,
    this.totalPages,
    this.totalResults,
  });

  factory GetCommentData.fromJson(Map<String, dynamic> json) => GetCommentData(
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
  String? userName;
  String? userId;
  String? comment;
  String? avatar;
  String? createdAt;
  String? updatedAt;
  String? id;

  Result({
    this.userName,
    this.userId,
    this.comment,
    this.avatar,
    this.createdAt,
    this.updatedAt,
    this.id,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        userName: json["userName"],
        userId: json["userId"],
        comment: json["comment"],
        avatar: json["userAvatar"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "userName": userName,
        "userId": userId,
        "comment": comment,
        "userAvatar": avatar,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "id": id,
      };
}

class Error {
  Error();

  factory Error.fromJson(Map<String, dynamic> json) => Error();

  Map<String, dynamic> toJson() => {};
}
