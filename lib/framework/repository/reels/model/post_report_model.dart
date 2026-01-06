// To parse this JSON data, do
//
//     final postReportResponseModel = postReportResponseModelFromJson(jsonString);

import 'dart:convert';

PostReportResponseModel postReportResponseModelFromJson(String str) =>
    PostReportResponseModel.fromJson(json.decode(str));

String postReportResponseModelToJson(PostReportResponseModel data) =>
    json.encode(data.toJson());

class PostReportResponseModel {
  Error? error;
  Data? data;
  int? code;
  String? message;
  bool? success;

  PostReportResponseModel({
    this.error,
    this.data,
    this.code,
    this.message,
    this.success,
  });

  factory PostReportResponseModel.fromJson(Map<String, dynamic> json) =>
      PostReportResponseModel(
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
  String? userId;
  String? query;
  String? reply;
  String? status;
  String? date;
  String? id;

  Data({
    this.userId,
    this.query,
    this.reply,
    this.status,
    this.date,
    this.id,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        userId: json["userId"],
        query: json["query"],
        reply: json["reply"],
        status: json["status"],
        date: json["date"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "query": query,
        "reply": reply,
        "status": status,
        "date": date,
        "id": id,
      };
}

class Error {
  Error();

  factory Error.fromJson(Map<String, dynamic> json) => Error();

  Map<String, dynamic> toJson() => {};
}
