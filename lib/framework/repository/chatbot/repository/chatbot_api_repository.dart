import 'dart:convert';

import 'package:injectable/injectable.dart';

import '../../../../ui/utils/const/app_constants.dart';
import '../../../provider/network/network.dart';
import '../contract/chatbot_repository.dart';

@LazySingleton(as: ChatbotRepository, env: [development, production])
class ChatbotApiRepository implements ChatbotRepository {
  ChatbotApiRepository(this.apiClient);

  DioClient apiClient;

  @override
  Future sendToChatBotAPI({required Map<String, dynamic> map}) async {
    try {
      String jsonString = json.encode(map);
      Response? response =
          await apiClient.postRequest(ApiEndPoints.chatBot, jsonString);
      // ChatbotMessageResponse responseModel = ChatbotMessageResponse();
      if (response?.statusCode == ApiEndPoints.apiStatus_200) {
        return ApiResult.success(data: response);
      } else {
        return ApiResult.failure(
            error:
                NetworkExceptions.defaultError(response?.statusMessage ?? ''));
      }
    } catch (err) {
      showLog('sendToChatBotAPI API Error -> err $err');
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }
}
