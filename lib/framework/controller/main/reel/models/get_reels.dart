// To parse this JSON data, do
//
//     final getReelsResponse = getReelsResponseFromJson(jsonString);

import 'dart:convert';

GetReelsResponse getReelsResponseFromJson(String str) =>
    GetReelsResponse.fromJson(json.decode(str));

String getReelsResponseToJson(GetReelsResponse data) =>
    json.encode(data.toJson());

class GetReelsResponse {
  Result? result;

  GetReelsResponse({
    this.result,
  });

  factory GetReelsResponse.fromJson(Map<String, dynamic> json) =>
      GetReelsResponse(
        result: json["result"] == null ? null : Result.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "result": result?.toJson(),
      };
}

class Result {
  List<ReelData>? data;

  Result({
    this.data,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        data: json["data"] == null
            ? []
            : List<ReelData>.from(
                json["data"]!.map((x) => ReelData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class ReelData {
  int? position;
  String? type;
  Data? data;

  ReelData({
    this.position,
    this.type,
    this.data,
  });

  factory ReelData.fromJson(Map<String, dynamic> json) => ReelData(
        position: json["position"],
        type: json["type"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "position": position,
        "type": type,
        "data": data?.toJson(),
      };
}

class Data {
  String? reelId;
  String? uploadedBy;
  int? views;
  String? type;
  List<dynamic>? tags;
  bool? isDeleted;
  String? videoName;
  String? videoContentType;
  String? company;
  bool? isApproved;
  String? status;
  List<dynamic>? comments;
  String? createdAt;
  String? updatedAt;
  String? videoUrl;
  String? description;
  String? title;

  Data({
    this.reelId,
    this.uploadedBy,
    this.views,
    this.type,
    this.tags,
    this.isDeleted,
    this.videoName,
    this.videoContentType,
    this.company,
    this.isApproved,
    this.status,
    this.comments,
    this.createdAt,
    this.updatedAt,
    this.videoUrl,
    this.description,
    this.title,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        reelId: json["reelId"],
        uploadedBy: json["uploadedBy"],
        views: json["views"],
        type: json["type"],
        tags: json["tags"] == null
            ? []
            : List<dynamic>.from(json["tags"]!.map((x) => x)),
        isDeleted: json["isDeleted"],
        videoName: json["videoName"],
        videoContentType: json["videoContentType"],
        company: json["company"],
        isApproved: json["isApproved"],
        status: json["status"],
        comments: json["comments"] == null
            ? []
            : List<dynamic>.from(json["comments"]!.map((x) => x)),
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        videoUrl: json["videoUrl"],
        description: json["description"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "reelId": reelId,
        "uploadedBy": uploadedBy,
        "views": views,
        "type": type,
        "tags": tags == null ? [] : List<dynamic>.from(tags!.map((x) => x)),
        "isDeleted": isDeleted,
        "videoName": videoName,
        "videoContentType": videoContentType,
        "company": company,
        "isApproved": isApproved,
        "status": status,
        "comments":
            comments == null ? [] : List<dynamic>.from(comments!.map((x) => x)),
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "videoUrl": videoUrl,
        "description": description,
        "title": title,
      };
}
