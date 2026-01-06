import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:vista_flicks/framework/repository/chatbot/contract/chatbot_repository.dart';
import 'package:vista_flicks/framework/utils/local_storage/session.dart';

import '../../../../ui/utils/helper/chatbot_manager/chatbot_manager.dart';
import '../../../../ui/utils/theme/theme.dart';
import '../../../../ui/utils/widgets/common_dialogs.dart';
import '../../../dependency_injection/inject.dart';
import '../../../provider/network/api_result.dart';
import '../../../provider/network/network_exceptions.dart';
import '../../../repository/chatbot/model/chatbot_message_response.dart';
import '../../../repository/common_response/common_response_model.dart';
import '../../../utils/ui_state.dart';

final chatbotController =
    ChangeNotifierProvider((ref) => getIt<ChatbotController>());

@injectable
class ChatbotController extends ChangeNotifier {
  ChatbotRepository chatbotRepository;
  ScrollController scrollController = ScrollController();

  TextEditingController reportController = TextEditingController();
  bool isStarted = false;

  void scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 20), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 10),
          curve: Curves.easeOut,
        );
      }
    });
  }

  final StreamController<List<ChatbotMessageResponse>>
      _messageStreamController =
      StreamController<List<ChatbotMessageResponse>>.broadcast();

  Stream<List<ChatbotMessageResponse>> get messageStream =>
      _messageStreamController.stream;

  final List<ChatbotMessageResponse> _messages = [
    ChatbotMessageResponse(
      id: Session.userId,
      sender: 'bot',
      messageText: "Hi there! I'm  Flixy!",
      createdAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
    ),
    ChatbotMessageResponse(
      sender: 'bot',
      id: Session.userId,
      messageText:
          "Looking for a great movie to watch or need details about a film?\nJust ask me — I'll help you with suggestions, cast info, genres, ratings & more from our movie library! 🍿✨",
      createdAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
    )
  ];

  ChatbotController(this.chatbotRepository);
  updateMessages() {
    _messageStreamController.add(_messages);
    // Listen to new messages
    ChatbotManager.instance.getMessagesStream().listen((newMessages) {
      try {
        List<ChatbotMessageResponse> updatedMessages = [
          // Always include greeting messages
          ChatbotMessageResponse(
            id: Session.userId,
            sender: 'bot',
            messageText: "Hi there! I'm  Flixy!",
            createdAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
          ),
          ChatbotMessageResponse(
            sender: 'bot',
            id: Session.userId,
            messageText:
                "Looking for a great movie to watch or need details about a film?\nJust ask me — I'll help you with suggestions, cast info, genres, ratings & more from our movie library! 🍿✨",
            createdAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
          ),
        ];

        // Add new messages if any
        if (newMessages.isNotEmpty) {
          updatedMessages.addAll(newMessages);
          isStarted = true;
        } else {
          isStarted = false;
        }

        // Update the messages list
        _messages.clear();
        _messages.addAll(updatedMessages);

        // Add to stream only if controller is not closed
        if (!_messageStreamController.isClosed) {
          _messageStreamController.add(_messages);
        }

        // Scroll to bottom after messages are updated
        if (newMessages.isNotEmpty) {
          scrollToBottomWhenKeyboardOpen();
        }
        notifyListeners();
      } catch (e) {
        print('Error updating messages: $e');
      }
    });
  }

  updateWidget() {
    notifyListeners();
  }

  UIState<ChatbotMessageResponse> chatBotAPIState =
      UIState<ChatbotMessageResponse>();

  void scrollToBottomWhenKeyboardOpen() {
    // if (!scrollController.hasClients) return;

    Future.delayed(const Duration(milliseconds: 100), () {
      // if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
      );
      // }
    });
  }

  Future<void> sendToChatBotAPI(
    BuildContext context, {
    required String inputTxt,
    bool isStarted = false,
  }) async {
    try {
      chatBotAPIState.isLoading = true;
      notifyListeners();

      Map<String, dynamic> map = {
        "query": inputTxt,
        // "k": 5,
        // "threshold": 0.5,
      };
      ApiResult apiResult = await chatbotRepository.sendToChatBotAPI(map: map);

      apiResult.when(
        success: (data) async {
          // final ChatbotMessageData parsedDataList = ChatbotMessageData(
          //   genreDetails: data.data['genreDetails'],
          //   ottPlatforms: data.data['ottPlatforms'],
          //   posterPath: data.data['posterPath'],
          //   title: data.data['title'],
          //   id: data.data['id'],
          // );
          List<ChatbotMessageData> parsedDataList = (data.data['data'] as List)
              .map((item) =>
                  ChatbotMessageData.fromJson(item as Map<String, dynamic>))
              .toList();

          log("parsedDataList $parsedDataList");

          // final List<TopMatch> parsedTopMatches = (data.data['top_matches']
          //         as List)
          //     .map((item) => TopMatch.fromJson(item as Map<String, dynamic>))
          //     .toList();

          // Create bot response
          final botResponse = ChatbotMessageResponse(
            sender: 'bot',
            createdAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
            data: parsedDataList,
            // topMatches: parsedTopMatches,
            messageText: inputTxt,
            type: data.data['type'],
            id: Session.userId,
          );

          // Save bot response
          ChatbotManager.instance.saveBotResponse(botResponse);

          chatBotAPIState.isLoading = false;
          notifyListeners();
        },
        failure: (NetworkExceptions error) {
          chatBotAPIState.isLoading = false;
          String errorMsg = NetworkExceptions.getErrorMessage(error);

          error.whenOrNull(
            notFound: (reason, response) {
              CommonResponseModel commonResponseModel =
                  commonResponseModelFromJson(response.toString());
              errorMsg = commonResponseModel.message ?? '';
            },
          );
          showMessageDialog(context, errorMsg, null);
          notifyListeners();
        },
      );
    } catch (e) {
      chatBotAPIState.isLoading = false;
      showMessageDialog(context, e.toString(), null);
      notifyListeners();
    }
  }

  Future<void> submitReport(Map<String, dynamic> reportPayload) async {
    try {
      log("Submitting report with payload: $reportPayload");
      await ChatbotManager.instance.reportMessage(reportPayload);
    } catch (e) {
      log(e.toString());
    }
  }

  void sendMessage(BuildContext context, String message, bool isStarted) async {
    try {
      scrollToBottomWhenKeyboardOpen();
      final tempMessage = ChatbotMessageResponse(
        id: Session.userId,
        sender: "user",
        messageText: message,
        createdAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      );
      this.isStarted = true;

      // Create user message
      ChatbotManager.instance.createChatMessage(message, 'user');

      if (isStarted == false) {
        await sendToChatBotAPI(context, inputTxt: message);
      }
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    _messageStreamController.close();
    super.dispose();
  }
}
