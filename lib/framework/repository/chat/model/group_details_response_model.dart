// To parse this JSON data, do
//
//     final groupDetailsResponseModel = groupDetailsResponseModelFromJson(jsonString);

import 'dart:convert';

List<GroupDetailsResponseModel> groupDetailsResponseModelFromJson(String str) => List<GroupDetailsResponseModel>.from(json.decode(str).map((x) => GroupDetailsResponseModel.fromJson(x)));

String groupDetailsResponseModelToJson(List<GroupDetailsResponseModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GroupDetailsResponseModel {
  List<Admin>? admins;
  String? createdAt;
  String? groupName;
  bool? isGroup;
  LastMessage? lastMessage;
  List<Admin>? members;
  List<LastMessage>? unreadCount;
  String? updatedAt;
  List<String>? memberIds;
  List<String>? adminIds;
  bool? isMembersCanInvite;
  String? groupId;

  GroupDetailsResponseModel({
    this.admins,
    this.createdAt,
    this.groupName,
    this.isGroup,
    this.lastMessage,
    this.members,
    this.unreadCount,
    this.updatedAt,
    this.memberIds,
    this.adminIds,
    this.isMembersCanInvite,
    this.groupId,
  });

  factory GroupDetailsResponseModel.fromJson(Map<String, dynamic> json) => GroupDetailsResponseModel(
        admins: json["admins"] == null ? [] : List<Admin>.from(json["admins"]!.map((x) => Admin.fromJson(x))),
        createdAt: json["created_at"],
        groupName: json["groupName"],
        isGroup: json["is_group"],
        lastMessage: json["last_message"] == null ? null : LastMessage.fromJson(json["last_message"]),
        members: json["members"] == null ? [] : List<Admin>.from(json["members"]!.map((x) => Admin.fromJson(x))),
        unreadCount: json["unread_count"] == null ? [] : List<LastMessage>.from(json["unread_count"]!.map((x) => LastMessage.fromJson(x))),
        updatedAt: json["updated_at"],
        memberIds: json["member_ids"] == null ? [] : List<String>.from(json["member_ids"]!.map((x) => x)),
        adminIds: json["adminIds"] == null ? [] : List<String>.from(json["adminIds"]!.map((x) => x)),
        isMembersCanInvite: json["isMembersCanInvite"],
        groupId: json["groupId"],
      );

  Map<String, dynamic> toJson() => {
        "admins": admins == null ? [] : List<dynamic>.from(admins!.map((x) => x.toJson())),
        "created_at": createdAt,
        "groupName": groupName,
        "is_group": isGroup,
        "last_message": lastMessage?.toJson(),
        "members": members == null ? [] : List<dynamic>.from(members!.map((x) => x.toJson())),
        "unread_count": unreadCount == null ? [] : List<dynamic>.from(unreadCount!.map((x) => x.toJson())),
        "updated_at": updatedAt,
        "member_ids": memberIds == null ? [] : List<dynamic>.from(memberIds!.map((x) => x)),
        "adminIds": adminIds == null ? [] : List<dynamic>.from(adminIds!.map((x) => x)),
        "isMembersCanInvite": isMembersCanInvite,
        "groupId": groupId,
      };
}

class Admin {
  String? userId;
  String? userName;
  String? userImage;

  Admin({
    this.userId,
    this.userName,
    this.userImage,
  });

  factory Admin.fromJson(Map<String, dynamic> json) => Admin(
        userId: json["user_id"],
        userName: json["user_name"],
        userImage: json["user_image"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "user_name": userName,
        "user_image": userImage,
      };
}

class LastMessage {
  String? userId;
  String? userName;
  String? userImage;
  String? message;
  String? messageId;
  String? createdAt;
  String? messageType;

  LastMessage({
    this.userId,
    this.userName,
    this.userImage,
    this.message,
    this.messageId,
    this.createdAt,
    this.messageType,
  });

  factory LastMessage.fromJson(Map<String, dynamic> json) => LastMessage(
        userId: json["user_id"],
        userName: json["user_name"],
        userImage: json["user_image"],
        message: json["message"],
        messageId: json["messageId"],
        createdAt: json["created_at"],
        messageType: json["message_type"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "user_name": userName,
        "user_image": userImage,
        "message": message,
        "messageId": messageId,
        "created_at": createdAt,
        "message_type": messageType,
      };
}
