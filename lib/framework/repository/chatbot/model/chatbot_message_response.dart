// To parse this JSON data, do
//
//     final chatbotMessageResponse = chatbotMessageResponseFromJson(jsonString);

import 'dart:convert';

ChatbotMessageResponse chatbotMessageResponseFromJson(String str) =>
    ChatbotMessageResponse.fromJson(json.decode(str));

String chatbotMessageResponseToJson(ChatbotMessageResponse data) =>
    json.encode(data.toJson());

class ChatbotMessageResponse {
  String? type;
  String? id;
  String? messageText;
  String? sender;
  int? createdAt;
  List<ChatbotMessageData>? data;
  bool? isReported;
  Map<String, dynamic>? reportMessage;

  ChatbotMessageResponse({
    this.type,
    this.id,
    this.messageText,
    this.sender,
    this.createdAt,
    this.data,
    this.isReported,
    this.reportMessage,
  });

  factory ChatbotMessageResponse.fromJson(Map<String, dynamic> json) =>
      ChatbotMessageResponse(
        type: json["type"],
        id: json["id"],
        messageText: json["messageText"],
        sender: json["sender"],
        createdAt: json["createdAt"],
        data: json["data"] == null
            ? []
            : List<ChatbotMessageData>.from(
                json["data"]!.map((x) => ChatbotMessageData.fromJson(x))),
        isReported: json["isReported"],
        reportMessage: json["reportMessage"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class ChatbotMessageData {
  String? id;
  String? title;
  String? genreDetails;
  String? ottPlatforms;
  String? posterPath;
  String? response;
  String? poster;

  ChatbotMessageData({
    this.id,
    this.title,
    this.genreDetails,
    this.ottPlatforms,
    this.posterPath,
    this.response,
    this.poster,
  });

  factory ChatbotMessageData.fromJson(Map<String, dynamic> json) =>
      ChatbotMessageData(
        id: json["_id"],
        title: json["title"],
        genreDetails: json["genreDetails"],
        ottPlatforms: json["ottPlatforms"],
        posterPath: json["posterPath"],
        response: json["response"],
        poster: json["poster"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "genreDetails": genreDetails,
        "ottPlatforms": ottPlatforms,
        "posterPath": posterPath,
        "response": response,
        "poster": poster,
      };
}
