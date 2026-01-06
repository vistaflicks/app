// To parse this JSON data, do
//
//     final termsOfUseResponseModel = termsOfUseResponseModelFromJson(jsonString);

import 'dart:convert';

TermsOfUseResponseModel termsOfUseResponseModelFromJson(String str) =>
    TermsOfUseResponseModel.fromJson(json.decode(str));

String termsOfUseResponseModelToJson(TermsOfUseResponseModel data) =>
    json.encode(data.toJson());

class TermsOfUseResponseModel {
  Error? error;
  TermsOfUseData? data;
  int? code;
  String? message;
  bool? success;

  TermsOfUseResponseModel({
    this.error,
    this.data,
    this.code,
    this.message,
    this.success,
  });

  factory TermsOfUseResponseModel.fromJson(Map<String, dynamic> json) =>
      TermsOfUseResponseModel(
        error: json["error"] == null ? null : Error.fromJson(json["error"]),
        data:
            json["data"] == null ? null : TermsOfUseData.fromJson(json["data"]),
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

class TermsOfUseData {
  List<Result>? results;
  int? page;
  int? limit;
  int? totalPages;
  int? totalResults;

  TermsOfUseData({
    this.results,
    this.page,
    this.limit,
    this.totalPages,
    this.totalResults,
  });

  factory TermsOfUseData.fromJson(Map<String, dynamic> json) => TermsOfUseData(
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
  String? question;
  String? answer;
  String? id;

  Result({
    this.question,
    this.answer,
    this.id,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        question: json["question"],
        answer: json["answer"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "question": question,
        "answer": answer,
        "id": id,
      };
}

class Error {
  Error();

  factory Error.fromJson(Map<String, dynamic> json) => Error();

  Map<String, dynamic> toJson() => {};
}
