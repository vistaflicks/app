// To parse this JSON data, do
//
//     final commonResponseModel = commonResponseModelFromJson(jsonString);

import 'dart:convert';

DrawerModel drawerResponseModelFromJson(String str) =>
    DrawerModel.fromJson(json.decode(str));

String drawerResponseModelToJson(DrawerModel data) =>
    json.encode(data.toJson());

class DrawerModel {
  int id;
  String title;
  String img;

  DrawerModel({
    required this.id,
    required this.title,
    required this.img,
  });

  factory DrawerModel.fromJson(Map<String, dynamic> json) => DrawerModel(
        id: json['id'],
        img: json['img'],
        title: json['title'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'img': img,
        'title': title,
      };
}
