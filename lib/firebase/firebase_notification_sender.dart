import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:vista_flicks/ui/utils/const/app_constants.dart';

class FirebaseNotificationSender {
  static final Dio _dio = Dio();
  static const String _fcmUrl = 'https://fcm.googleapis.com/fcm/send';
  // WARNING: Do not store the server key in client-side code in a production app.
  // This should be stored securely on a server.
  static const String _serverKey = 'YOUR_FCM_SERVER_KEY';

  static Future<void> sendPushNotification({
    required String token,
    required String title,
    required String body,
    Map<String, dynamic>? payload,
  }) async {
    final data = {
      "to": token,
      "notification": {
        "title": title,
        "body": body,
      },
      "priority": "high",
      "data": payload,
    };

    try {
      await _dio.post(
        _fcmUrl,
        data: jsonEncode(data),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'key=$_serverKey',
          },
        ),
      );
      showLog('Push notification sent successfully.');
    } catch (e) {
      showLog('Error sending push notification: $e');
    }
  }
}
