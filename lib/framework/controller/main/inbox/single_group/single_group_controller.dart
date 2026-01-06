import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:vista_flicks/framework/repository/chat/model/group_details_response_model.dart';
import 'package:vista_flicks/framework/repository/chat/model/message_list_response_model.dart';
import 'package:vista_flicks/framework/utils/local_storage/session.dart';
import 'package:vista_flicks/ui/routing/navigation_stack_item.dart';
import 'package:vista_flicks/ui/routing/stack.dart';
import 'package:vista_flicks/ui/utils/const/app_constants.dart';
import 'package:vista_flicks/ui/utils/const/app_enums.dart';
import 'package:vista_flicks/ui/utils/helper/group_chat_manager/group_chat_manager.dart';
import 'package:vista_flicks/ui/utils/widgets/common_dialogs.dart';

import '../../../../../ui/screens/main/inbox/helper/join_group_dialog.dart';
import '../../../../../ui/utils/theme/theme.dart';
import '../../../../dependency_injection/inject.dart';

final singleGroupController =
    ChangeNotifierProvider((ref) => getIt<SingleGroupController>());

@injectable
class SingleGroupController extends ChangeNotifier {
  QRViewController? qrViewController;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String? qrText;

  bool isLoading = false;

  updateIsLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  final TextEditingController textController = TextEditingController();
  final List<Message> messages = [];

  List<MessageListResponseModel> messageList = [];
  GroupDetailsResponseModel? getGroupDetailsResponseModel;

  void sendMessage({MessageMedia? media, required String groupId}) async {
    if (textController.text.trim().isNotEmpty || media != null) {
      String messageContent = textController.text;
      GroupChatManager.instance.sendGroupMessage(
        model: MessageListResponseModel(
          groupId: groupId,
          content: textController.text.isEmpty ? null : textController.text,
          messageId: null,
          status: 'Sent',
          createdAt: DateTime.now().toString(),
          media: media,
          messageType: MessageType.text.name,
          sendBy: Session.userId,
          sendByName: '${Session.userFirstName} ${Session.userLastName}',
          sendByImage: Session.userProfileImage,
        ),
      );
      textController.clear();

      if (groupId != '') {
        getGroupMessages(groupId: groupId);

        // // Send push notifications to group members
        // try {
        //   final groupDetails =
        //       await GroupChatManager.instance.getGroupDetails(groupId);
        //   if (groupDetails != null && groupDetails.memberIds != null) {
        //     for (String memberId in groupDetails.memberIds!) {
        //       if (memberId != Session.userId) {
        //         final userDoc = await FirebaseFirestore.instance
        //             .collection('users')
        //             .doc(memberId)
        //             .get();
        //         if (userDoc.exists &&
        //             userDoc.data()!.containsKey('device_fcm_token')) {
        //           final token = userDoc.get('device_fcm_token');
        //           if (token != null && token.isNotEmpty) {
        //             await FirebaseNotificationSender.sendPushNotification(
        //               token: token,
        //               title: groupDetails.groupName ?? 'New Message',
        //               body:
        //                   '${Session.userFirstName} ${Session.userLastName}: ${media != null ? "Sent an attachment" : messageContent}',
        //               payload: {'groupId': groupId},
        //             );
        //           }
        //         }
        //       }
        //     }
        //   }
        // } catch (e) {
        //   showLog("Error sending push notifications: $e");
        // }
      }
      notifyListeners();
    }
  }

  void disposeQrViewController({bool isUpdateGroupResponse = true}) {
    qrText = null;
    qrViewController?.dispose();
    if (isUpdateGroupResponse) {
      getGroupDetailsResponseModel = null;
    }
    notifyListeners();
  }

  void onQRViewCreated(
      BuildContext context, QRViewController controller, WidgetRef ref) {
    try {
      updateIsLoading(true);
      qrViewController = controller;
      qrViewController?.scannedDataStream.listen((scanData) async {
        qrText = scanData.code;

        if (qrText != null) {
          qrViewController?.pauseCamera();

          await getGroupDetails(qrText?.split('groupId=').last ?? '');
          showLog(
              'qrText?.split(groupId=).last ${qrText?.split('groupId=').last}');

          if (getGroupDetailsResponseModel != null) {
            if (context.mounted) {
              showWidgetDialog(
                  context,
                  JoinGroupDialog(
                    groupId: getGroupDetailsResponseModel?.groupId ?? '',
                    onJoinCall: () async {
                      Navigator.of(context).pop();
                      bool isJoined = await GroupChatManager.instance.joinGroup(
                          getGroupDetailsResponseModel?.groupId ?? '');
                      showLog(
                          'isJoined isJoined isJoined isJoined isJoined $isJoined');
                      if (isJoined) {
                        disposeQrViewController(isUpdateGroupResponse: false);
                        showLog('Test 1 $isJoined');
                        ref.read(navigationStackController).pop();
                        showLog('Test 2 $isJoined');

                        ref.read(navigationStackController).push(
                            NavigationStackItem.singleGroup(
                                groupDetailsResponseModel:
                                    getGroupDetailsResponseModel));
                        showLog('Test 3 $isJoined');
                      }
                    },
                    onCancelCall: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  () {});
            }
          }
        }
        notifyListeners();
      });

      updateIsLoading(false);
    } catch (e) {
      showLog('Error in joining Group $e');
    } finally {
      updateIsLoading(false);
    }
    notifyListeners();
  }

  // Future<Stream<List<MessageListResponseModel>>> getGroupMessages({required String groupId}) async {
  //   // messageList.clear();
  //   // messageList = await GroupChatManager.instance.getAllGroupMessages(groupId);
  //   return GroupChatManager.instance.getGroupMessages(groupId);
  //   notifyListeners();
  // }

  Stream<List<MessageListResponseModel>> getGroupMessages(
      {required String groupId}) {
    return FirebaseFirestore.instance
        .collection('conversation')
        .doc(groupId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();

              final encryptedMessage = data['content'];
              // final decryptedContent = (encryptedMessage != null && encryptedMessage is String)
              //     ? EncryptionService.decrypt(encryptedMessage)
              //     : '';
              final decryptedContent = encryptedMessage;

              return MessageListResponseModel(
                messageId: doc.id,
                content: decryptedContent,
                messageType: data['messageType'] ?? 'text',
                createdAt: data['createdAt'] ?? '',
                // createdAt: (data['timestamp'] as Timestamp?)
                //         ?.toDate()
                //         .toIso8601String() ??
                //     '',
                status: data['status'] ?? 'sent',
                sendBy: data['sendBy'] ?? '',
                sendByName: data['sendByName'] ?? '',
                sendByImage: data['sendByImage'] ?? '',
                groupId: groupId,
                media: data['media'] != null
                    ? MessageMedia.fromJson(
                        Map<String, dynamic>.from(data['media']))
                    : null,
              );
            }).toList());
  }

  /// Get Group Details
  Future<void> getGroupDetails(String groupId) async {
    getGroupDetailsResponseModel = null;
    getGroupDetailsResponseModel =
        await GroupChatManager.instance.getGroupDetails(groupId);
    notifyListeners();
  }

  void disposeController({bool isNotify = false}) {
    isLoading = false;
    messageList.clear();
    getGroupDetailsResponseModel = null;
    if (isNotify) {
      notifyListeners();
    }
  }
}

class Message {
  final String text;
  final bool isMe;

  Message({required this.text, required this.isMe});
}
