// To parse this JSON data, do
//
//     final getBookMarkWatchResponse = getBookMarkWatchResponseFromJson(jsonString);

import 'dart:convert';

GetBookMarkWatchResponse getBookMarkWatchResponseFromJson(String str) =>
    GetBookMarkWatchResponse.fromJson(json.decode(str));

String getBookMarkWatchResponseToJson(GetBookMarkWatchResponse data) =>
    json.encode(data.toJson());

class GetBookMarkWatchResponse {
  Error? error;
  dynamic? data;
  int? code;
  String? message;
  bool? success;

  GetBookMarkWatchResponse({
    this.error,
    this.data,
    this.code,
    this.message,
    this.success,
  });

  factory GetBookMarkWatchResponse.fromJson(Map<String, dynamic> json) =>
      GetBookMarkWatchResponse(
        error: json["error"] == null ? null : Error.fromJson(json["error"]),
        data: json["data"] == null
            ? null
            : json["data"] is bool
                ? json["data"]
                : Data.fromJson(json["data"]),
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
  List<Content>? content;

  Data({
    this.content,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        content: json["content"] == null
            ? []
            : List<Content>.from(
                json["content"]!.map((x) => Content.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "content": content == null
            ? []
            : List<dynamic>.from(content!.map((x) => x.toJson())),
      };
}

class Content {
  String? contentId;
  bool? isBookmarked;
  bool? isWatched;

  Content({
    this.contentId,
    this.isBookmarked,
    this.isWatched,
  });

  factory Content.fromJson(Map<String, dynamic> json) => Content(
        contentId: json["contentId"],
        isBookmarked: json["isBookmarked"],
        isWatched: json["isWatched"],
      );

  Map<String, dynamic> toJson() => {
        "contentId": contentId,
        "isBookmarked": isBookmarked,
        "isWatched": isWatched,
      };
}

class Error {
  Error();

  factory Error.fromJson(Map<String, dynamic> json) => Error();

  Map<String, dynamic> toJson() => {};
}
