// To parse this JSON data, do
//
//     final getSearchResponse = getSearchResponseFromJson(jsonString);

import 'dart:convert';

GetSearchResponse getSearchResponseFromJson(String str) =>
    GetSearchResponse.fromJson(json.decode(str));

String getSearchResponseToJson(GetSearchResponse data) =>
    json.encode(data.toJson());

class GetSearchResponse {
  Error? error;
  Data? data;
  int? code;
  String? message;
  bool? success;

  GetSearchResponse({
    this.error,
    this.data,
    this.code,
    this.message,
    this.success,
  });

  factory GetSearchResponse.fromJson(Map<String, dynamic> json) =>
      GetSearchResponse(
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
  List<GetSearchRecentSearch>? recentSearches;
  List<GetSearchData>? movies;
  List<GetSearchData>? webseries;
  SearchAdsBanner? searchAdsBanner;

  Data({
    this.recentSearches,
    this.movies,
    this.webseries,
    this.searchAdsBanner,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        recentSearches: json["recentSearches"] == null
            ? []
            : List<GetSearchRecentSearch>.from(json["recentSearches"]!
                .map((x) => GetSearchRecentSearch.fromJson(x))),
        movies: json["movies"] == null
            ? []
            : List<GetSearchData>.from(
                json["movies"]!.map((x) => GetSearchData.fromJson(x))),
        webseries: json["webseries"] == null
            ? []
            : List<GetSearchData>.from(
                json["webseries"]!.map((x) => GetSearchData.fromJson(x))),
        searchAdsBanner: json["searchAdsBanner"] == null
            ? null
            : SearchAdsBanner.fromJson(json["searchAdsBanner"]),
      );

  Map<String, dynamic> toJson() => {
        "recentSearches": recentSearches == null
            ? []
            : List<dynamic>.from(recentSearches!.map((x) => x.toJson())),
        "movies": movies == null
            ? []
            : List<dynamic>.from(movies!.map((x) => x.toJson())),
        "webseries": webseries == null
            ? []
            : List<dynamic>.from(webseries!.map((x) => x.toJson())),
        "searchAdsBanner": searchAdsBanner?.toJson(),
      };
}

class GetSearchData {
  String? name;
  String? imageUrl;
  String? castName;
  String? contentId;
  final List<Reel>? reels;
  GetSearchData({
    this.name,
    this.imageUrl,
    this.castName,
    this.contentId,
    this.reels,
  });

  factory GetSearchData.fromJson(Map<String, dynamic> json) => GetSearchData(
        name: json["name"],
        imageUrl: json["imageUrl"],
        castName: json["castName"],
        contentId: json["contentId"],
        reels: json["reels"] == null
            ? []
            : List<Reel>.from(json["reels"]!.map((x) => Reel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "imageUrl": imageUrl,
        "castName": castName,
        "contentId": contentId,
        "reels": reels == null
            ? []
            : List<dynamic>.from(reels!.map((x) => x.toJson())),
      };
}

class Reel {
  final String? videoUrl;
  final String? contentId;
  final String? thumbnailUrl;
  final String? id;

  Reel({
    this.videoUrl,
    this.contentId,
    this.thumbnailUrl,
    this.id,
  });

  factory Reel.fromJson(Map<String, dynamic> json) => Reel(
        videoUrl: json["videoUrl"],
        contentId: json["contentId"],
        thumbnailUrl: json["thumbnailUrl"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "videoUrl": videoUrl,
        "contentId": contentId,
        "thumbnailUrl": thumbnailUrl,
        "id": id,
      };
}

class GetSearchRecentSearch {
  String? searchTerm;
  int? searchCount;
  String? searchTime;

  GetSearchRecentSearch({
    this.searchTerm,
    this.searchCount,
    this.searchTime,
  });

  factory GetSearchRecentSearch.fromJson(Map<String, dynamic> json) =>
      GetSearchRecentSearch(
        searchTerm: json["searchTerm"],
        searchCount: json["searchCount"],
        searchTime: json["searchTime"],
      );

  Map<String, dynamic> toJson() => {
        "searchTerm": searchTerm,
        "searchCount": searchCount,
        "searchTime": searchTime,
      };
}

class SearchAdsBanner {
  String? bannerImage;
  String? contentId;

  SearchAdsBanner({
    this.bannerImage,
    this.contentId,
  });

  factory SearchAdsBanner.fromJson(Map<String, dynamic> json) =>
      SearchAdsBanner(
        bannerImage: json["bannerImage"],
        contentId: json["contentId"],
      );

  Map<String, dynamic> toJson() => {
        "bannerImage": bannerImage,
        "contentId": contentId,
      };
}

class Error {
  Error();

  factory Error.fromJson(Map<String, dynamic> json) => Error();

  Map<String, dynamic> toJson() => {};
}
