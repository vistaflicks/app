// To parse this JSON data, do
//
//     final bookmarkBannerListResponseModel = bookmarkBannerListResponseModelFromJson(jsonString);

import 'dart:convert';

BookmarkBannerListResponseModel bookmarkBannerListResponseModelFromJson(
        String str) =>
    BookmarkBannerListResponseModel.fromJson(json.decode(str));

String bookmarkBannerListResponseModelToJson(
        BookmarkBannerListResponseModel data) =>
    json.encode(data.toJson());

class BookmarkBannerListResponseModel {
  Error? error;
  List<BookmarkBanner>? data;
  int? code;
  String? message;
  bool? success;

  BookmarkBannerListResponseModel({
    this.error,
    this.data,
    this.code,
    this.message,
    this.success,
  });

  factory BookmarkBannerListResponseModel.fromJson(Map<String, dynamic> json) =>
      BookmarkBannerListResponseModel(
        error: json["error"] == null ? null : Error.fromJson(json["error"]),
        data: json["data"] == null
            ? []
            : List<BookmarkBanner>.from(
                json["data"]!.map((x) => BookmarkBanner.fromJson(x))),
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

class BookmarkBanner {
  String? contentId;
  String? imageUrl;
  int? priority;
  String? title;

  BookmarkBanner({
    this.contentId,
    this.imageUrl,
    this.priority,
    this.title,
  });

  factory BookmarkBanner.fromJson(Map<String, dynamic> json) => BookmarkBanner(
        contentId: json["contentId"],
        imageUrl: json["imageUrl"],
        priority: json["priority"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "contentId": contentId,
        "imageUrl": imageUrl,
        "priority": priority,
        "title": title,
      };
}

class Error {
  Error();

  factory Error.fromJson(Map<String, dynamic> json) => Error();

  Map<String, dynamic> toJson() => {};
}

// // To parse this JSON data, do
// //
// //     final bookmarkBannerListResponseModel = bookmarkBannerListResponseModelFromJson(jsonString);
//
// import 'dart:convert';
//
// BookmarkBannerListResponseModel bookmarkBannerListResponseModelFromJson(String str) => BookmarkBannerListResponseModel.fromJson(json.decode(str));
//
// String bookmarkBannerListResponseModelToJson(BookmarkBannerListResponseModel data) => json.encode(data.toJson());
//
// class BookmarkBannerListResponseModel {
//   Error? error;
//   List<BookmarkBanner>? data;
//   int? code;
//   String? message;
//   bool? success;
//
//   BookmarkBannerListResponseModel({
//     this.error,
//     this.data,
//     this.code,
//     this.message,
//     this.success,
//   });
//
//   factory BookmarkBannerListResponseModel.fromJson(Map<String, dynamic> json) => BookmarkBannerListResponseModel(
//         error: json["error"] == null ? null : Error.fromJson(json["error"]),
//         data: json["data"] == null ? [] : List<BookmarkBanner>.from(json["data"]!.map((x) => BookmarkBanner.fromJson(x))),
//         code: json["code"],
//         message: json["message"],
//         success: json["success"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "error": error?.toJson(),
//         "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
//         "code": code,
//         "message": message,
//         "success": success,
//       };
// }
//
// class BookmarkBanner {
//   String? contentId;
//   String? imageUrl;
//   String? title;
//   int? priority;
//
//   BookmarkBanner({
//     this.contentId,
//     this.imageUrl,
//     this.title,
//     this.priority,
//   });
//
//   factory BookmarkBanner.fromJson(Map<String, dynamic> json) => BookmarkBanner(
//         contentId: json["contentId"],
//         imageUrl: json["imageUrl"],
//         title: json["title"],
//         priority: json["priority"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "contentId": contentId,
//         "imageUrl": imageUrl,
//         "title": title,
//         "priority": priority,
//       };
// }
//
// class Error {
//   Error();
//
//   factory Error.fromJson(Map<String, dynamic> json) => Error();
//
//   Map<String, dynamic> toJson() => {};
// }
