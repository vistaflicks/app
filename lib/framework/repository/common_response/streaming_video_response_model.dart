// To parse this JSON data, do
//
//     final streamingVideoResponseModel = streamingVideoResponseModelFromJson(jsonString);

import 'dart:convert';

StreamingVideoResponseModel streamingVideoResponseModelFromJson(String str) => StreamingVideoResponseModel.fromJson(json.decode(str));

String streamingVideoResponseModelToJson(StreamingVideoResponseModel data) => json.encode(data.toJson());

class StreamingVideoResponseModel {
  List<VideoData>? data;

  StreamingVideoResponseModel({
    this.data,
  });

  factory StreamingVideoResponseModel.fromJson(Map<String, dynamic> json) => StreamingVideoResponseModel(
    data: json["data"] == null ? [] : List<VideoData>.from(json["data"]!.map((x) => VideoData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class VideoData {
  String? id;
  String? title;
  String? url;
  bool? isWorking;

  VideoData({
    this.id,
    this.title,
    this.url,
    this.isWorking,
  });

  factory VideoData.fromJson(Map<String, dynamic> json) => VideoData(
    id: json["id"],
    title: json["title"],
    url: json["url"],
    isWorking: json["is_working"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "url": url,
    "is_working": isWorking,
  };
}
