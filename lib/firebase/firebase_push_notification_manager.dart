import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vista_flicks/framework/utils/local_storage/session.dart';
import 'package:vista_flicks/ui/utils/const/app_constants.dart';
import 'package:vista_flicks/ui/utils/theme/app_colors.dart';

class FirebasePushNotificationManager {
  FirebasePushNotificationManager._privateConstructor();

  static final FirebasePushNotificationManager instance = FirebasePushNotificationManager._privateConstructor();

  factory FirebasePushNotificationManager() {
    return instance;
  }

  FirebaseMessaging? firebaseMessaging;

  /// Flutter Local Notification
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Initial code for main.dart void main
  Future<void> setupInteractedMessage(BuildContext context, WidgetRef ref) async {
    await Firebase.initializeApp();
    showLog('setupInteractedMessage Called');

    // Get the FCM Token
    String? token = await FirebaseMessaging.instance.getToken();
    showLog('FCM Token: $token');
    Session.deviceFCMToken = (token ?? '');

    ///Received Notification click event after background notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      showLog('Getting notification in Background mode=>>>> ${json.encode(message.data)}');
      _onReceiveNotification(ref, message);
    });

    await enableIOSNotifications();
    if (context.mounted) {
      await registerNotificationListeners(context, ref);
    }
  }

  Future<void> registerNotificationListeners(BuildContext context, WidgetRef ref) async {
    /// Android Setup
    final AndroidNotificationChannel channel = androidNotificationChannel();

    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);

    /// Add Notification app icon
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@drawable/ic_app_logo');

    /// Sound and other permissions for IOS Side
    DarwinInitializationSettings iOSSettings = const DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    /// Received Notification click event after click on local notification
    InitializationSettings initSettings = InitializationSettings(android: androidSettings, iOS: iOSSettings);
    flutterLocalNotificationsPlugin.initialize(
      initSettings,

      /// On get Notification
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        showLog('NotificationResponse details......${details.toString()}');
        Map<String, dynamic> data = jsonDecode(details.payload ?? '');
        _onReceiveNotification(ref, RemoteMessage(data: data));
      },
    );

    ///Received Notification click event after App killed state
    firebaseMessaging?.getInitialMessage().then((message) async {
      if (message != null) {
        showLog('Getting notification in Terminated mode=>>>> ${json.encode(message.data)}');
        _onReceiveNotification(ref, message);
      }
    });

    /// onMessage is called when the app is in foreground and a notification is received
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) async {
        /// Api Calls when receiving notification on Foreground
      showLog('onMessage.listen onMessage.listen onMessage.listen ${message.notification}');
        final RemoteNotification? notification = message.notification;
        final AndroidNotification? android = message.notification?.android;

        if (notification != null && android != null) {
          /// Show customizable Notification Code
          flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                fullScreenIntent: true,
                color: AppColors.primary,
                icon: '@drawable/ic_app_logo',
              ),
            ),
            payload: jsonEncode(message.data),
          );
        }
      },
    );
  }

  Future<void> enableIOSNotifications() async {
    await FirebaseMessaging.instance.setAutoInitEnabled(true);

    /// Notification Settings
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  /// Android
  AndroidNotificationChannel androidNotificationChannel() => const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        description: 'This channel is used for important notifications.',
        importance: Importance.max,
      );

  ///Notification tap event method
  _onReceiveNotification(WidgetRef ref, RemoteMessage message) async {
    showLog('_onReceiveNotification Called++++++++++');
    showLog('Push Data - ${message.data.toString()}');
  }

  /// Show Notification
// Future<void> _showNotification() async {
//   /// Flutter Local Notification
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//   print('showNotification Called');
//   const AndroidNotificationDetails androidNotificationDetails =
//       AndroidNotificationDetails('your channel id', 'your channel name',
//           channelDescription: 'your channel description',
//           importance: Importance.max,
//           priority: Priority.high,
//           ticker: 'ticker');
//   const NotificationDetails notificationDetails =
//       NotificationDetails(android: androidNotificationDetails);
//   await flutterLocalNotificationsPlugin.show(
//       3, 'plain title', 'plain body', notificationDetails,
//       payload: 'item x');
// }
}
