import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vista_flicks/framework/repository/chat/model/create_group_request_model.dart';
import 'package:vista_flicks/framework/repository/chat/model/group_details_response_model.dart';
import 'package:vista_flicks/framework/repository/chat/model/message_list_response_model.dart';
import 'package:vista_flicks/framework/utils/local_storage/session.dart';
import 'package:vista_flicks/ui/utils/const/app_constants.dart';
import 'package:vista_flicks/ui/utils/helper/group_chat_manager/encryption_service.dart';

class GroupChatManager {
  GroupChatManager._privateConstructor();

  static final GroupChatManager instance =
      GroupChatManager._privateConstructor();

  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  Future<String> createGroup({
    required CreateGroupRequestModel model,
  }) async {
    final groupData = {
      "admins": [
        {
          "user_id": model.admins?.first.userId,
          "user_name": model.admins?.first.userName,
          "user_image": model.admins?.first.userImage,
        }
      ],
      "created_at": model.createdAt,
      "created_by": Session.userId,
      "created_name": '${Session.userFirstName} ${Session.userLastName}',
      "groupName": model.groupName,
      "is_group": model.isGroup,
      "last_message": model.lastMessage,
      "members": [
        {
          "user_id": model.admins?.first.userId,
          "user_name": model.admins?.first.userName,
          "user_image": model.admins?.first.userImage,
        }
      ],
      "member_ids": model.memberIds,
      "adminIds": model.adminIds,
      "unread_count": model.unreadCount,
      "updated_at": model.updatedAt,
      "isMembersCanInvite": model.isMembersCanInvite,
      "groupId": null,
    };

    try {
      CollectionReference groups = fireStore.collection('conversation');

      DocumentReference groupRef = await groups.add(groupData);

      String groupId = groupRef.id;

      showLog("Group '${model.groupName}' created successfully!");

      /// Update Group Id in Response
      final groupDetails =
          FirebaseFirestore.instance.collection('conversation').doc(groupId);
      final groupSnap = await groupRef.get();

      if (groupSnap.exists) {
        await groupDetails.update({
          "groupId": groupId,
        });
      }

      return '$staticGroupChatUrl$groupId';
    } catch (e) {
      showLog("Error creating group: $e");
      return '';
    }
  }

  /// Get Groups List
  Stream<List<GroupDetailsResponseModel>> getGroupsStream(String userId) {
    return FirebaseFirestore.instance
        .collection('conversation')
        .where('member_ids', arrayContains: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              data['groupId'] =
                  doc.id; // optional if you want to keep the Firestore doc ID
              return GroupDetailsResponseModel.fromJson(data);
            }).toList());
  }

  /// Get filtered group list (where user is member and group name contains search query)
  Stream<List<GroupDetailsResponseModel>> searchGroups(
      String userId, String searchQuery) {
    return FirebaseFirestore.instance
        .collection('conversation')
        .where('member_ids', arrayContains: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) {
              final data = doc.data();
              data['groupId'] = doc.id;
              return GroupDetailsResponseModel.fromJson(data);
            })
            .where((group) =>
                group.groupName != null &&
                group.groupName!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()))
            .toList());
  }

  Future<bool> joinGroup(String groupId) async {
    try {
      final userData = {
        "user_id": Session.userId,
        "user_image": Session.userProfileImage,
        "user_name": '${Session.userFirstName} ${Session.userLastName}',
      };

      final groupRef =
          FirebaseFirestore.instance.collection('conversation').doc(groupId);
      final groupSnap = await groupRef.get();

      if (groupSnap.exists) {
        if (groupSnap.data()?['isMembersCanInvite']) {
          await groupRef.update({
            "members": FieldValue.arrayUnion([userData]),
            "member_ids": FieldValue.arrayUnion([Session.userId]),
            "adminIds": FieldValue.arrayUnion([Session.userId]),
            "admins": FieldValue.arrayUnion([userData])
          });
          return true;
        } else {
          await groupRef.update({
            "members": FieldValue.arrayUnion([userData]),
            "member_ids": FieldValue.arrayUnion([Session.userId])
          });
          return true;
        }
      }
    } catch (e) {
      showLog('Check error log while joining group $e');
      return false;
    }
    return false;
  }

  /// Send Group Message
  Future<void> sendGroupMessage({
    required MessageListResponseModel model,
  }) async {
    showLog('group Id ${model.groupId}');
    showLog('senderId Id ${model.sendBy}');

    // final encryptedMessage = EncryptionService.encrypt(model.content ?? '');
    final encryptedMessage = model.content ?? '';

    final messageData = {
      "messageId": model.messageId,
      "content": encryptedMessage,
      "messageType": model.messageType,
      "createdAt": model.createdAt,
      "status": model.status,
      "sendBy": model.sendBy,
      "media": model.media?.toJson(),
      "groupId": model.groupId,
      "sendByName": model.sendByName,
      "sendByImage": model.sendByImage,
    };

    CollectionReference groups = fireStore
        .collection('conversation')
        .doc(model.groupId)
        .collection('messages');

    DocumentReference groupRef = await groups.add(messageData);

    String messageId = groupRef.id;

    /// Update Message Id in Response
    final messageDetails = fireStore
        .collection('conversation')
        .doc(model.groupId)
        .collection('messages')
        .doc(messageId);
    final groupSnap = await groupRef.get();

    if (groupSnap.exists) {
      await messageDetails.update({
        "messageId": messageId,
      });
    }
  }

  /// Update Message Status
  Future<void> updateMessageStatus(
      {required String messageId, required String groupId}) async {
    /// Update Message Id in Response
    final messageDetails = fireStore
        .collection('conversation')
        .doc(groupId)
        .collection('messages')
        .doc(messageId);

    await messageDetails.update({
      "status": 'Read',
    });
  }

  Stream<List<MessageListResponseModel>> getGroupMessages(String groupId) {
    return FirebaseFirestore.instance
        .collection('conversation')
        .doc(groupId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();

              final encryptedMessage = data['message'];
              final decryptedContent =
                  (encryptedMessage != null && encryptedMessage is String)
                      ? EncryptionService.decrypt(encryptedMessage)
                      : '';

              return MessageListResponseModel(
                messageId: doc.id,
                content: decryptedContent,
                messageType: data['messageType'] ?? 'text',
                createdAt: (data['timestamp'] as Timestamp?)
                        ?.toDate()
                        .toIso8601String() ??
                    '',
                status: data['status'] ?? 'sent',
                sendBy: data['senderId'] ?? '',
                groupId: groupId,
                media: data['media'] != null
                    ? MessageMedia.fromJson(
                        Map<String, dynamic>.from(data['media']))
                    : null,
                sendByName: data['sendByName'] ?? '',
                sendByImage: data['sendByImage'] ?? '',
              );
            }).toList());
  }

  /// Get Group Details
  Future<GroupDetailsResponseModel?> getGroupDetails(String groupId) async {
    try {
      DocumentSnapshot groupDoc =
          await fireStore.collection('conversation').doc(groupId).get();

      if (groupDoc.exists) {
        final data = groupDoc.data() as Map<String, dynamic>;

        data['groupId'] = groupDoc.id;

        return GroupDetailsResponseModel.fromJson(data);
      } else {
        showLog("Group not found");
        return null;
      }
    } catch (e) {
      showLog("Error fetching group: $e");
      return null;
    }
  }

  /// Leave Group
  Future<bool> leaveGroup(String groupId) async {
    try {
      final groupRef = fireStore.collection('conversation').doc(groupId);

      final userData = {
        "user_id": Session.userId,
        "user_image": Session.userProfileImage,
        "user_name": '${Session.userFirstName} ${Session.userLastName}',
      };

      final groupSnap = await groupRef.get();

      if (groupSnap.exists) {
        await groupRef.update({
          "members": FieldValue.arrayRemove([userData]),
          "member_ids": FieldValue.arrayRemove([Session.userId]),
          "admins": FieldValue.arrayRemove([userData]),
          "adminIds": FieldValue.arrayRemove([Session.userId]),
        });

        return true;
      }
    } catch (e) {
      showLog('Error leaving group: $e');
      return false;
    }

    return false;
  }

  Future<bool> removeMember({
    required String groupId,
    required String userId,
    required String userName,
    required String userImage,
  }) async {
    try {
      final groupRef =
          FirebaseFirestore.instance.collection('conversation').doc(groupId);

      final userData = {
        "user_id": userId,
        "user_name": userName,
        "user_image": userImage,
      };

      final groupSnap = await groupRef.get();

      if (groupSnap.exists) {
        await groupRef.update({
          "members": FieldValue.arrayRemove([userData]),
          "member_ids": FieldValue.arrayRemove([userId]),
          "admins": FieldValue.arrayRemove([userData]),
          "adminIds": FieldValue.arrayRemove([userId]),
        });

        return true;
      }
    } catch (e) {
      showLog('Error removing member: $e');
      return false;
    }

    return false;
  }
}
