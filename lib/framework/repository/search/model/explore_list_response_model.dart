// To parse this JSON data, do
//
//     final exploreListResponseModel = exploreListResponseModelFromJson(jsonString);

import 'dart:convert';

ExploreListResponseModel exploreListResponseModelFromJson(String str) =>
    ExploreListResponseModel.fromJson(json.decode(str));

String exploreListResponseModelToJson(ExploreListResponseModel data) =>
    json.encode(data.toJson());

class ExploreListResponseModel {
  Error? error;
  ExploreData? data;
  int? code;
  String? message;
  bool? success;

  ExploreListResponseModel({
    this.error,
    this.data,
    this.code,
    this.message,
    this.success,
  });

  factory ExploreListResponseModel.fromJson(Map<String, dynamic> json) =>
      ExploreListResponseModel(
        error: json["error"] == null ? null : Error.fromJson(json["error"]),
        data: json["data"] == null ? null : ExploreData.fromJson(json["data"]),
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

class ExploreData {
  List<BannerData>? bannerData;
  List<TitleDatum>? titleData;

  ExploreData({
    this.bannerData,
    this.titleData,
  });

  factory ExploreData.fromJson(Map<String, dynamic> json) => ExploreData(
        bannerData: json["bannerData"] == null
            ? []
            : List<BannerData>.from(
                json["bannerData"]!.map((x) => BannerData.fromJson(x))),
        titleData: json["titleData"] == null
            ? []
            : List<TitleDatum>.from(
                json["titleData"]!.map((x) => TitleDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "bannerData": bannerData == null
            ? []
            : List<dynamic>.from(bannerData!.map((x) => x.toJson())),
        "titleData": titleData == null
            ? []
            : List<dynamic>.from(titleData!.map((x) => x.toJson())),
      };
}

class BannerData {
  String? imageUrl;
  dynamic contentId;

  BannerData({
    this.imageUrl,
    this.contentId,
  });

  factory BannerData.fromJson(Map<String, dynamic> json) => BannerData(
        imageUrl: json["imageUrl"],
        contentId: json["contentId"] == null
            ? null
            : json["contentId"] is String
                ? json["contentId"]
                : ContentIdElement.fromJson(json["contentId"]),
      );

  Map<String, dynamic> toJson() => {
        "imageUrl": imageUrl,
        "contentId": contentId?.toJson(),
      };
}

class ContentIdElement {
  String? title;
  String? posterPath;
  String? id;

  ContentIdElement({
    this.title,
    this.posterPath,
    this.id,
  });

  factory ContentIdElement.fromJson(Map<String, dynamic> json) =>
      ContentIdElement(
        title: json["title"],
        posterPath: json["posterPath"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "posterPath": posterPath,
        "id": id,
      };
}

class TitleDatum {
  String? title;
  List<CategoryData>? data;
  bool? isBanner;

  TitleDatum({
    this.title,
    this.data,
    this.isBanner,
  });

  factory TitleDatum.fromJson(Map<String, dynamic> json) => TitleDatum(
      title: json["title"],
      data: json["data"] == null
          ? []
          : List<CategoryData>.from(
              json["data"]!.map((x) => CategoryData.fromJson(x))),
      isBanner: "${json["title"]}".contains("Banner Ad"));

  Map<String, dynamic> toJson() => {
        "title": title,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "isBanner": isBanner
      };
}

class CategoryData {
  String? name;
  String? imageUrl;
  dynamic contentId;
  int? position;
  List<ContentIdElement>? content;

  CategoryData({
    this.name,
    this.imageUrl,
    this.contentId,
    this.position,
    this.content,
  });

  factory CategoryData.fromJson(Map<String, dynamic> json) => CategoryData(
        name: json["name"],
        imageUrl: json["imageUrl"],
        contentId: json["contentId"],
        position: json["position"],
        content: json["content"] == null
            ? []
            : List<ContentIdElement>.from(
                json["content"]!.map((x) => ContentIdElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "imageUrl": imageUrl,
        "contentId": contentId,
        "position": position,
        "content": content == null
            ? []
            : List<dynamic>.from(content!.map((x) => x.toJson())),
      };
}

class Error {
  Error();

  factory Error.fromJson(Map<String, dynamic> json) => Error();

  Map<String, dynamic> toJson() => {};
}

// // To parse this JSON data, do
// //
// //     final exploreListResponseModel = exploreListResponseModelFromJson(jsonString);
//
// import 'dart:convert';
//
// ExploreListResponseModel exploreListResponseModelFromJson(String str) =>
//     ExploreListResponseModel.fromJson(json.decode(str));
//
// String exploreListResponseModelToJson(ExploreListResponseModel data) =>
//     json.encode(data.toJson());
//
// class ExploreListResponseModel {
//   Error? error;
//   ExploreData? data;
//   int? code;
//   String? message;
//   bool? success;
//
//   ExploreListResponseModel({
//     this.error,
//     this.data,
//     this.code,
//     this.message,
//     this.success,
//   });
//
//   factory ExploreListResponseModel.fromJson(Map<String, dynamic> json) =>
//       ExploreListResponseModel(
//         error: json["error"] == null ? null : Error.fromJson(json["error"]),
//         data: json["data"] == null ? null : ExploreData.fromJson(json["data"]),
//         code: json["code"],
//         message: json["message"],
//         success: json["success"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "error": error?.toJson(),
//         "data": data?.toJson(),
//         "code": code,
//         "message": message,
//         "success": success,
//       };
// }
//
// class ExploreData {
//   List<BannerData>? bannerData;
//   List<TitleDatum>? titleData;
//
//   ExploreData({
//     this.bannerData,
//     this.titleData,
//   });
//
//   factory ExploreData.fromJson(Map<String, dynamic> json) => ExploreData(
//         bannerData: json["bannerData"] == null
//             ? []
//             : List<BannerData>.from(
//                 json["bannerData"]!.map((x) => BannerData.fromJson(x))),
//         titleData: json["titleData"] == null
//             ? []
//             : List<TitleDatum>.from(
//                 json["titleData"]!.map((x) => TitleDatum.fromJson(x))),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "bannerData": bannerData == null
//             ? []
//             : List<dynamic>.from(bannerData!.map((x) => x.toJson())),
//         "titleData": titleData == null
//             ? []
//             : List<dynamic>.from(titleData!.map((x) => x.toJson())),
//       };
// }
//
// class BannerData {
//   String? imageUrl;
//   String? contentId;
//   String? title;
//   dynamic priority;
//
//   BannerData({
//     this.imageUrl,
//     this.contentId,
//     this.title,
//     this.priority,
//   });
//
//   factory BannerData.fromJson(Map<String, dynamic> json) => BannerData(
//       imageUrl: json["imageUrl"],
//       contentId: json["contentId"],
//       priority: json["priority"],
//       title: json['title']
//       // == null
//       //     ? null
//       //     : ContentIdElement.fromJson(json["contentId"]),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "imageUrl": imageUrl,
//         "contentId": contentId,
//         "title": title,
//         "priority": priority
//       };
// }
//
// class ContentIdElement {
//   String? title;
//   String? posterPath;
//   String? id;
//
//   ContentIdElement({
//     this.title,
//     this.posterPath,
//     this.id,
//   });
//
//   factory ContentIdElement.fromJson(Map<String, dynamic> json) =>
//       ContentIdElement(
//         title: json["title"],
//         posterPath: json["posterPath"],
//         id: json["id"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "title": title,
//         "posterPath": posterPath,
//         "id": id,
//       };
// }
//
// class TitleDatum {
//   String? title;
//   List<CategoryData>? data;
//   bool? isBanner;
//
//   TitleDatum({
//     this.title,
//     this.data,
//     this.isBanner,
//   });
//
//   factory TitleDatum.fromJson(Map<String, dynamic> json) => TitleDatum(
//         title: json["title"],
//         data: json["data"] == null
//             ? []
//             : List<CategoryData>.from(
//                 json["data"]!.map((x) => CategoryData.fromJson(x))),
//         isBanner: json["isBanner"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "title": title,
//         "data": data == null
//             ? []
//             : List<dynamic>.from(data!.map((x) => x.toJson())),
//         "isBanner": isBanner,
//       };
// }
//
// class CategoryData {
//   String? name;
//   String? imageUrl;
//   String? contentId;
//   dynamic content;
//
//   CategoryData({
//     this.name,
//     this.imageUrl,
//     this.contentId,
//     this.content,
//   });
//
//   factory CategoryData.fromJson(Map<String, dynamic> json) => CategoryData(
//         name: json["name"],
//         imageUrl: json["imageUrl"],
//         contentId: json["contentId"],
//         content: json["content"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "name": name,
//         "imageUrl": imageUrl,
//         "contentId": contentId,
//         "content": content,
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
