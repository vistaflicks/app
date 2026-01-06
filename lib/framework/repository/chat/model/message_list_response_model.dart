// To parse this JSON data, do
//
//     final messageListResponseModel = messageListResponseModelFromJson(jsonString);

import 'dart:convert';

List<MessageListResponseModel> messageListResponseModelFromJson(String str) =>
    List<MessageListResponseModel>.from(
        json.decode(str).map((x) => MessageListResponseModel.fromJson(x)));

String messageListResponseModelToJson(List<MessageListResponseModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MessageListResponseModel {
  String? messageId;
  String? content;
  String? messageType;
  String? createdAt;
  String? status;
  String? sendBy;
  String? sendByName;
  String? sendByImage;
  String? groupId;
  MessageMedia? media;

  MessageListResponseModel({
    this.messageId,
    this.content,
    this.messageType,
    this.createdAt,
    this.status,
    this.sendBy,
    this.media,
    this.groupId,
    this.sendByName,
    this.sendByImage,
  });

  factory MessageListResponseModel.fromJson(Map<String, dynamic> json) =>
      MessageListResponseModel(
        messageId: json["messageId"],
        content: json["content"],
        messageType: json["messageType"],
        createdAt: json["createdAt"],
        status: json["status"],
        sendBy: json["sendBy"],
        media:
            json["media"] == null ? null : MessageMedia.fromJson(json["media"]),
        groupId: json["groupId"],
        sendByName: json["sendByName"],
        sendByImage: json["sendByImage"],
      );

  Map<String, dynamic> toJson() => {
        "messageId": messageId,
        "content": content,
        "messageType": messageType,
        "createdAt": createdAt,
        "status": status,
        "sendBy": sendBy,
        "media": media?.toJson(),
        "groupId": groupId,
        "sendByName": sendByName,
        "sendByImage": sendByImage,
      };
}

class MessageMedia {
  String? mediaUrl;
  String? mediaType;
  String? mediaId;
  String? mediaReelId;

  MessageMedia({
    this.mediaUrl,
    this.mediaType,
    this.mediaId,
    this.mediaReelId,
  });

  factory MessageMedia.fromJson(Map<String, dynamic> json) => MessageMedia(
        mediaUrl: json["media_url"],
        mediaType: json["media_type"],
        mediaId: json["media_id"],
        mediaReelId: json["media_reel_id"],
      );

  Map<String, dynamic> toJson() => {
        "media_url": mediaUrl,
        "media_type": mediaType,
        "media_id": mediaId,
        "media_reel_id": mediaReelId,
      };
}
