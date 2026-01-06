// To parse this JSON data, do
//
//     final updatePreferencesRequestModel = updatePreferencesRequestModelFromJson(jsonString);

import 'dart:convert';

UpdatePreferencesRequestModel updatePreferencesRequestModelFromJson(
        String str) =>
    UpdatePreferencesRequestModel.fromJson(json.decode(str));

String updatePreferencesRequestModelToJson(
        UpdatePreferencesRequestModel data) =>
    json.encode(data.toJson());

class UpdatePreferencesRequestModel {
  List<String>? genre;
  List<String>? language;
  List<String>? subTitleLanguage;
  List<String>? imdbRating;
  List<String>? region;
  List<String>? ageRating;
  List<String>? ottPlatforms;
  List<String>? contentType;

  UpdatePreferencesRequestModel({
    this.genre,
    this.language,
    this.subTitleLanguage,
    this.imdbRating,
    this.region,
    this.ageRating,
    this.ottPlatforms,
    this.contentType,
  });

  factory UpdatePreferencesRequestModel.fromJson(Map<String, dynamic> json) =>
      UpdatePreferencesRequestModel(
        genre: json["genre"] == null
            ? []
            : List<String>.from(json["genre"]!.map((x) => x)),
        language: json["language"] == null
            ? []
            : List<String>.from(json["language"]!.map((x) => x)),
        subTitleLanguage: json["subTitleLanguage"] == null
            ? []
            : List<String>.from(json["subTitleLanguage"]!.map((x) => x)),
        imdbRating: json["imdbRating"] == null
            ? []
            : List<String>.from(json["imdbRating"]!.map((x) => x)),
        region: json["region"] == null
            ? []
            : List<String>.from(json["region"]!.map((x) => x)),
        ageRating: json["ageRating"] == null
            ? []
            : List<String>.from(json["ageRating"]!.map((x) => x)),
        ottPlatforms: json["ottPlatforms"] == null
            ? []
            : List<String>.from(json["ottPlatforms"]!.map((x) => x)),
        contentType: json["contentType"] == null
            ? []
            : List<String>.from(json["contentType"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "genre": genre == null ? [] : List<dynamic>.from(genre!.map((x) => x)),
        "language":
            language == null ? [] : List<dynamic>.from(language!.map((x) => x)),
        "subTitleLanguage": subTitleLanguage == null
            ? []
            : List<dynamic>.from(subTitleLanguage!.map((x) => x)),
        "imdbRating": imdbRating == null
            ? []
            : List<dynamic>.from(imdbRating!.map((x) => x)),
        "region":
            region == null ? [] : List<dynamic>.from(region!.map((x) => x)),
        "ageRating": ageRating == null
            ? []
            : List<dynamic>.from(ageRating!.map((x) => x)),
        "ottPlatforms": ottPlatforms == null
            ? []
            : List<dynamic>.from(ottPlatforms!.map((x) => x)),
        "contentType": contentType == null
            ? []
            : List<dynamic>.from(contentType!.map((x) => x)),
      };
}
