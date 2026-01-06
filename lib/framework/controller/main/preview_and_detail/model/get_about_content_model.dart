// To parse this JSON data, do
//
//     final getAboutContentModel = getAboutContentModelFromJson(jsonString);

import 'dart:convert';

GetAboutContentModel getAboutContentModelFromJson(String str) =>
    GetAboutContentModel.fromJson(json.decode(str));

String getAboutContentModelToJson(GetAboutContentModel data) =>
    json.encode(data.toJson());

class GetAboutContentModel {
  Error? error;
  Data? data;
  int? code;
  String? message;
  bool? success;

  GetAboutContentModel({
    this.error,
    this.data,
    this.code,
    this.message,
    this.success,
  });

  factory GetAboutContentModel.fromJson(Map<String, dynamic> json) =>
      GetAboutContentModel(
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
  String? id;
  String? title;
  String? posterPath;
  String? duration;
  String? releaseDate;
  List<Genre>? genres;
  List<Cast>? cast;
  List<Cast>? crew;
  dynamic imdbRating;
  dynamic reviews;
  String? about;

  Data({
    this.id,
    this.title,
    this.posterPath,
    this.duration,
    this.releaseDate,
    this.genres,
    this.cast,
    this.crew,
    this.imdbRating,
    this.reviews,
    this.about,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        title: json["title"],
        posterPath: json["posterPath"],
        duration: json["duration"],
        releaseDate: json["releaseDate"],
        genres: json["genres"] == null
            ? []
            : List<Genre>.from(json["genres"]!.map((x) => Genre.fromJson(x))),
        cast: json["cast"] == null
            ? []
            : List<Cast>.from(json["cast"]!.map((x) => Cast.fromJson(x))),
        crew: json["crew"] == null
            ? []
            : List<Cast>.from(json["crew"]!.map((x) => Cast.fromJson(x))),
        imdbRating: json["imdbRating"],
        reviews: json["reviews"],
        about: json["about"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "posterPath": posterPath,
        "duration": duration,
        "releaseDate": releaseDate,
        "genres": genres == null
            ? []
            : List<dynamic>.from(genres!.map((x) => x.toJson())),
        "cast": cast == null
            ? []
            : List<dynamic>.from(cast!.map((x) => x.toJson())),
        "crew": crew == null
            ? []
            : List<dynamic>.from(crew!.map((x) => x.toJson())),
        "imdbRating": imdbRating,
        "reviews": reviews,
        "about": about,
      };
}

class Cast {
  String? id;
  String? name;
  String? avatar;
  String? movieName;
  String? characterName;

  Cast({this.id, this.name, this.avatar, this.movieName, this.characterName});

  factory Cast.fromJson(Map<String, dynamic> json) => Cast(
        id: json["id"],
        name: json["name"],
        avatar: json["avatar"],
        movieName: json["movieName"],
        characterName: json["characterName"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "avatar": avatar,
        "movieName": movieName,
        "characterName": characterName,
      };
}

class Genre {
  String? id;
  String? name;

  Genre({
    this.id,
    this.name,
  });

  factory Genre.fromJson(Map<String, dynamic> json) => Genre(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class Error {
  Error();

  factory Error.fromJson(Map<String, dynamic> json) => Error();

  Map<String, dynamic> toJson() => {};
}
