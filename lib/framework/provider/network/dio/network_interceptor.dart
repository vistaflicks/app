import 'dart:convert';

import '../../../../ui/routing/delegate.dart';
import '../../../../ui/utils/const/app_constants.dart';
import '../../../../ui/utils/widgets/common_dialogs.dart';
import '../common_error_model.dart';
import '../network.dart';

bool enableLogoutDialog = true;

InterceptorsWrapper networkInterceptor() {
  CancelToken cancelToken = CancelToken();
  return InterceptorsWrapper(
    onRequest: (request, handler) {
      request.cancelToken = cancelToken;
      handler.next(request);
    },
    onResponse: (response, handler) {
      List<String> whiteListAPIs = [];
      try {
        if ((whiteListAPIs.contains(response.realUri.path)) &&
            (response.data is Map ||
                (response.data is String &&
                    response.data.toString().isNotEmpty))) {
          CommonErrorModel commonModel =
              CommonErrorModel.fromJson(jsonDecode(response.toString()));
          showLog('Network Interceptor On Success ${response.statusCode}');
          if (response.statusCode != ApiEndPoints.apiStatus_200) {
            if (globalNavigatorKey.currentState?.context != null) {
              showMessageDialog(globalNavigatorKey.currentState!.context,
                  response.statusMessage ?? '', null);
              return;
            }
          }
        }
        handler.next(response);
      } catch (e, s) {
        showLog('stacktrace $s');
        handler.reject(
            DioException(
                requestOptions: response.requestOptions,
                response: response,
                error: const NetworkExceptions.unexpectedError()),
            false);
      }
    },
    onError: (error, handler) async {
      final response = error.response;
      showLog(
          'Network Interceptor ON Error ${response?.statusCode ?? "Unknown Status"}');

      if (response?.statusCode == ApiEndPoints.apiStatus_401) {
        final context = globalNavigatorKey.currentState?.context;
        if (context != null) {
          await sessionExpiryDialog(context);
          return;
        }
        return; // Ensure error is not passed further after handling
      }

      showLog('Passing error to next handler');
      handler.next(error);
    },
  );
}
