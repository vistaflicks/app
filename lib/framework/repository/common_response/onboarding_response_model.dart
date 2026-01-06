// To parse this JSON data, do
//
//     final onboardingResponseModel = onboardingResponseModelFromJson(jsonString);

import 'dart:convert';

OnboardingResponseModel onboardingResponseModelFromJson(String str) => OnboardingResponseModel.fromJson(json.decode(str));

String onboardingResponseModelToJson(OnboardingResponseModel data) => json.encode(data.toJson());

class OnboardingResponseModel {
  List<Datum>? data;

  OnboardingResponseModel({
    this.data,
  });

  factory OnboardingResponseModel.fromJson(Map<String, dynamic> json) => OnboardingResponseModel(
    data: json['data'] == null ? [] : List<Datum>.from(json['data']!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    'data': data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  String? id;
  String? image;
  String? title;
  String? description;

  Datum({
    this.id,
    this.image,
    this.title,
    this.description,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json['id'],
    image: json['image'],
    title: json['title'],
    description: json['description'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'image': image,
    'title': title,
    'description': description,
  };
}
