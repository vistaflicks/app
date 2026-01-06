// To parse this JSON data, do
//
//     final getReelsListResponseModel = getReelsListResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:video_player/video_player.dart';

GetReelsListResponseModel getReelsListResponseModelFromJson(String str) =>
    GetReelsListResponseModel.fromJson(json.decode(str));

String getReelsListResponseModelToJson(GetReelsListResponseModel data) =>
    json.encode(data.toJson());

class GetReelsListResponseModel {
  Error? error;
  ReelsResult? data;
  int? code;
  String? message;
  bool? success;

  GetReelsListResponseModel({
    this.error,
    this.data,
    this.code,
    this.message,
    this.success,
  });

  factory GetReelsListResponseModel.fromJson(Map<String, dynamic> json) =>
      GetReelsListResponseModel(
        error: json["error"] == null ? null : Error.fromJson(json["error"]),
        data: json["data"] == null ? null : ReelsResult.fromJson(json["data"]),
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

class ReelsResult {
  List<ReelModel>? results;
  String? userType;
  int? totalResults;

  ReelsResult({
    this.results,
    this.userType,
    this.totalResults,
  });

  factory ReelsResult.fromJson(Map<String, dynamic> json) => ReelsResult(
        results: json["results"] == null
            ? []
            : List<ReelModel>.from(
                json["results"]!.map((x) => ReelModel.fromJson(x))),
        userType: json["userType"],
        totalResults: json["totalResults"],
      );

  Map<String, dynamic> toJson() => {
        "results": results == null
            ? []
            : List<dynamic>.from(results!.map((x) => x.toJson())),
        "userType": userType,
        "totalResults": totalResults,
      };
}

class ReelModel {
  String? videoUrl;
  String? thumbnailUrl;
  String? title;
  String? imageUrl;
  String? contentId;
  String? id;
  String? type;
  int? position;
  int? likes;
  int? shares;
  int? views;
  String? description;
  String? movieLogo;
  bool? showReelsAsAds;
  bool? isBookmarked;
  bool? isWatched;
  bool? isRated;
  double? rating;
  int? watchedCount;
  int? commentCount;
  bool? isLiked;
  List<OttPlatform>? ottPlatforms;
  BannerData? bannerData;
  bool? isPromoted;
  VideoPlayerController? videoPlayerController;
  UploadedBy? uploadedBy;

  ReelModel({
    this.videoUrl,
    this.thumbnailUrl,
    this.title,
    this.imageUrl,
    this.contentId,
    this.id,
    this.type,
    this.position,
    this.likes,
    this.shares,
    this.views,
    this.description,
    this.movieLogo,
    this.isBookmarked,
    this.isWatched,
    this.isRated,
    this.rating = 0.0,
    this.showReelsAsAds,
    this.watchedCount,
    this.commentCount,
    this.isLiked,
    this.ottPlatforms,
    this.bannerData,
    this.isPromoted,
    this.videoPlayerController,
    this.uploadedBy,
  });

  factory ReelModel.fromJson(Map<String, dynamic> json) => ReelModel(
        videoUrl: json["videoUrl"],
        thumbnailUrl: json["thumbnailUrl"],
        title: json["title"],
        imageUrl: json["imageUrl"],
        contentId: json["contentId"],
        id: json["id"],
        type: json["type"],
        showReelsAsAds: json["showReelsAsAds"],
        position: json["position"],
        likes: json["likes"],
        shares: json["shares"],
        views: json["views"],
        description: json["description"],
        movieLogo: json["movieLogo"],
        isBookmarked: json["isBookmarked"],
        isWatched: json["isWatched"],
        isRated: json["isRated"],
        watchedCount: json["watchedCount"],
        commentCount: json["commentCount"],
        isLiked: json["isLiked"],
        ottPlatforms: json["ottPlatforms"] == null
            ? []
            : List<OttPlatform>.from(
                json["ottPlatforms"]!.map((x) => OttPlatform.fromJson(x))),
        bannerData: json["bannerData"] == null
            ? null
            : BannerData.fromJson(json["bannerData"]),
        isPromoted: json["isPromoted"],
        uploadedBy: json["uploadedBy"] == null
            ? null
            : UploadedBy.fromJson(json["uploadedBy"]),
      );

  Map<String, dynamic> toJson() => {
        "videoUrl": videoUrl,
        "thumbnailUrl": thumbnailUrl,
        "title": title,
        "imageUrl": imageUrl,
        "contentId": contentId,
        "id": id,
        "showReelsAsAds": showReelsAsAds,
        "type": type,
        "position": position,
        "likes": likes,
        "shares": shares,
        "views": views,
        "description": description,
        "movieLogo": movieLogo,
        "isBookmarked": isBookmarked,
        "isWatched": isWatched,
        "isRated": isRated,
        "watchedCount": watchedCount,
        "commentCount": commentCount,
        "isLiked": isLiked,
        "ottPlatforms": ottPlatforms == null
            ? []
            : List<dynamic>.from(ottPlatforms!.map((x) => x.toJson())),
        "bannerData": bannerData?.toJson(),
        "isPromoted": isPromoted,
        "uploadedBy": uploadedBy?.toJson(),
      };
}

class BannerData {
  String? bannerImage;

  BannerData({
    this.bannerImage,
  });

  factory BannerData.fromJson(Map<String, dynamic> json) => BannerData(
        bannerImage: json["bannerImage"],
      );

  Map<String, dynamic> toJson() => {
        "bannerImage": bannerImage,
      };
}

class UploadedBy {
  final String? firstName;
  final String? lastName;
  final String? userName;

  UploadedBy({
    this.firstName,
    this.lastName,
    this.userName,
  });

  factory UploadedBy.fromJson(Map<String, dynamic> json) => UploadedBy(
        firstName: json["firstName"],
        lastName: json["lastName"],
        userName: json["userName"],
      );

  Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "lastName": lastName,
        "userName": userName,
      };
}

class OttPlatform {
  Id? id;
  dynamic destinationLink;

  OttPlatform({
    this.id,
    this.destinationLink,
  });

  factory OttPlatform.fromJson(Map<String, dynamic> json) => OttPlatform(
        id: json["id"] == null ? null : Id.fromJson(json["id"]),
        destinationLink: json["destinationLink"],
      );

  Map<String, dynamic> toJson() => {
        "id": id?.toJson(),
        "destinationLink": destinationLink,
      };
}

class Id {
  PackageName? packageName;
  String? name;
  String? id;

  Id({
    this.packageName,
    this.name,
    this.id,
  });

  factory Id.fromJson(Map<String, dynamic> json) => Id(
        packageName: json["packageName"] == null
            ? null
            : PackageName.fromJson(json["packageName"]),
        name: json["name"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "packageName": packageName?.toJson(),
        "name": name,
        "id": id,
      };
}

class PackageName {
  String? android;
  String? ios;

  PackageName({
    this.android,
    this.ios,
  });

  factory PackageName.fromJson(Map<String, dynamic> json) => PackageName(
        android: json["android"],
        ios: json["ios"],
      );

  Map<String, dynamic> toJson() => {
        "android": android,
        "ios": ios,
      };
}

class Error {
  Error();

  factory Error.fromJson(Map<String, dynamic> json) => Error();

  Map<String, dynamic> toJson() => {};
}
