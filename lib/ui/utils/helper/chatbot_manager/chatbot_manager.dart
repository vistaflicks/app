import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vista_flicks/framework/repository/chatbot/model/chatbot_message_response.dart';

import '../../../../framework/utils/local_storage/session.dart';

class ChatbotManager {
  ChatbotManager._privateConstructor();

  static final ChatbotManager instance = ChatbotManager._privateConstructor();

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  void createChatMessage(String msgTxt, String? user) async {
    final docRef = firestore
        .collection('chatBot')
        .doc(Session.userId)
        .collection('messages')
        .doc();

    await docRef.set({
      'id': docRef.id,
      'sender': 'user',
      'messageText': msgTxt,
      'createdAt': DateTime.now().millisecondsSinceEpoch ~/ 1000,
      'isReported': false,
      'reportMessage': null,
    });

    print("Chat message saved to 'chats' collection");
  }

  bool isUserFound = false;

  Future<void> getChatBotData() async {
    final userId = Session.userId;
    print('Checking Firestore messages for userId: $userId');

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('chatBot')
          .doc(userId)
          .collection('messages')
          .get();

      if (snapshot.docs.isNotEmpty) {
        print('true ✅ Messages found for this user in chatBot');
        print("snapoShot ===> ${snapshot.docs.first.data()}");
        isUserFound = true;
      } else {
        print('false ❌ No messages found under chatBot/$userId');
      }
    } catch (e) {
      print('Error checking Firestore messages: $e');
      print('false ❌');
    }
  }

  Stream<List<ChatbotMessageResponse>> getMessagesStream() {
    final data = firestore
        .collection('chatBot')
        .doc(Session.userId)
        .collection('messages')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              print("Get Data from firebase =-> ${data["sender"]}");
              return ChatbotMessageResponse.fromJson(data);
            }).toList());

    return data;
  }

  void saveBotResponse(ChatbotMessageResponse data) async {
    final docRef = firestore
        .collection('chatBot')
        .doc(Session.userId)
        .collection('messages')
        .doc();

    await docRef.set({
      "id": docRef.id,
      'sender': 'bot',
      'messageText': data.messageText,
      'createdAt': DateTime.now().millisecondsSinceEpoch ~/ 1000,
      'isReported': false,
      'reportMessage': null,
      ...data.toJson()
    });
  }

  Future<void> reportMessage(Map<String, dynamic> reportPayload) async {
    final messageId = reportPayload['messageId'];
    print("Reporting message with payload: $reportPayload");
    print("Extracted messageId: $messageId");
    if (messageId == null) {
      print("messageId is null, cannot report.");
      return;
    }

    final docRef = firestore
        .collection('chatBot')
        .doc(Session.userId)
        .collection('messages')
        .doc(messageId);

    await docRef.update({
      'isReported': true,
      'reportMessage': {
        'reason': reportPayload['reason'],
        'reportedAt': FieldValue.serverTimestamp(),
      }
    });
  }
}
