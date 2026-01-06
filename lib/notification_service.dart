import 'dart:io';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vista_flicks/ui/routing/navigation_stack_item.dart';
import 'package:vista_flicks/ui/routing/stack.dart';

class NotificationState {
  final bool isNavigating;
  final String? contentId;
  final String? reelId;
  final String? type;

  NotificationState({
    this.isNavigating = false,
    this.contentId,
    this.reelId,
    this.type,
  });

  NotificationState copyWith({
    bool? isNavigating,
    String? contentId,
    String? reelId,
    String? type,
  }) {
    return NotificationState(
      isNavigating: isNavigating ?? this.isNavigating,
      contentId: contentId ?? this.contentId,
      reelId: reelId ?? this.reelId,
      type: type ?? this.type,
    );
  }
}

// Provider for the NotificationController
final notificationControllerProvider =
    StateNotifierProvider<NotificationController, NotificationState>((ref) {
  return NotificationController(ref);
});

class NotificationController extends StateNotifier<NotificationState> {
  final Ref ref;

  NotificationController(this.ref) : super(NotificationState());

  // Handle the redirection logic based on notification payload
  void handleNotificationRedirection(
      BuildContext context, Map<String, dynamic> data) {
    if (state.isNavigating) {
      // Prevent duplicate navigation if already navigating
      return;
    }

    state = state.copyWith(isNavigating: true);

    String? contentId = data['contentId'];
    String? reelId = data['reelId'];
    String? type = data['type'];

    if (contentId != null && type != null) {
      // Set the state to navigate
      state = state.copyWith(contentId: contentId, reelId: reelId, type: type);

      // Handle navigation based on the notification type
      if (type == 'ADCAMPAIGN') {
        if (reelId != null) {
          ref.read(navigationStackController).push(
              NavigationStackItem.reel(reelId: reelId, contentId: contentId));
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => ReelScreen(
          //       reelId: reelId,
          //       contentId: contentId,
          //     ),
          //   ),
          // );
        } else {
          ref
              .read(navigationStackController)
              .push(NavigationStackItem.detail(contentId: contentId));
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => DetailScreen(
          //       contentId: contentId,
          //     ),
          //   ),
          // );
        }
      }

      // Reset navigation state after the navigation is done
      state = state.copyWith(isNavigating: false);
    }
  }
}

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void initLocalNotifications(
      BuildContext context, RemoteMessage message, WidgetRef ref) async {
    var androidInitializationSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitializationSettings = const DarwinInitializationSettings(
      defaultPresentAlert: true,
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestCriticalPermission: true,
      requestSoundPermission: true,
      requestProvisionalPermission: true,
      defaultPresentBanner: true,
      defaultPresentSound: true,
    );

    var initializationSetting = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializationSettings);

    await _flutterLocalNotificationsPlugin.initialize(initializationSetting,
        onDidReceiveNotificationResponse: (payload) {
      // handle interaction when app is active for android
      handleMessage(context, message, ref);
    });
  }

  void firebaseInit(BuildContext context, WidgetRef ref) {
    FirebaseMessaging.onMessage.listen((message) {
      print('Got a message whilst in the foreground!');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      var data = message.data;

      if (Platform.isIOS) {
        forgroundMessage();
      }

      if (Platform.isAndroid) {
        initLocalNotifications(context, message, ref);
        showNotification(message);
      }

      // Handle redirection logic using state management
      // Pass ref to handle the redirection
      ref
          .read(notificationControllerProvider.notifier)
          .handleNotificationRedirection(context, data);
    });
  }

  void requestNotificationPermission() async {
    await Permission.notification.request();

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('user granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('user granted provisional permission');
    } else {
      print('user denied permission');
    }
  }

  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = const AndroidNotificationChannel(
      "notification",
      "notification",
      importance: Importance.high,
      showBadge: true,
      playSound: true,
    );

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            channel.id.toString(), channel.name.toString(),
            channelDescription: 'your channel description',
            importance: Importance.high,
            priority: Priority.high,
            playSound: true,
            ticker: 'ticker');

    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
      presentBanner: true,
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);

    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
        Random().nextInt(100000),
        message.notification!.title.toString(),
        message.notification!.body.toString(),
        notificationDetails,
      );
    });
  }

  Future<String> getDeviceToken() async {
    await initializeFirebaseMessaging();
    String? token = await messaging.getToken();
    print("Device Token is $token");
    return token!;
  }

  Future<void> initializeFirebaseMessaging() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Step 1: Request permissions on iOS
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('🔔 Notification permission granted');

      // Step 2: Wait for APNs token to be set
      String? apnsToken;
      while (apnsToken == null) {
        apnsToken = await messaging.getAPNSToken();
        await Future.delayed(Duration(milliseconds: 200)); // small wait
      }

      debugPrint('📲 APNs Token: $apnsToken');

      // Step 3: Now get FCM token
      String? fcmToken = await messaging.getToken();
      debugPrint('🔥 Firebase Messaging Token: $fcmToken');
    } else {
      debugPrint('🚫 Notification permission denied');
    }
  }

  void isTokenRefresh() async {
    messaging.onTokenRefresh.listen((event) {
      event.toString();
      print('refresh');
    });
  }

  Future<void> setupInteractMessage(BuildContext context, WidgetRef ref) async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      Future.delayed(const Duration(seconds: 5), () {
        handleMessage(context, initialMessage, ref);
      });
    }

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(context, event, ref);
    });
  }

  String _parseRemoteData(Map<String, dynamic>? data) {
    String payload = '';
    if (data != null) {
      payload = data.toString();
    }
    return payload;
  }

  Map<String, dynamic> result = {};

  void handleMessage(
      BuildContext context, RemoteMessage message, WidgetRef ref) {
    String payload = _parseRemoteData(message.data);

    List<String> str =
        payload.replaceAll("{", "").replaceAll("}", "").split(",");
    for (int i = 0; i < str.length; i++) {
      List<String> s = str[i].split(":");
      result.putIfAbsent(s[0].trim(), () => s[1].trim());
    }

    if (payload.isNotEmpty) {
      // Handle redirection by passing the data to the controller
      ref
          .read(notificationControllerProvider.notifier)
          .handleNotificationRedirection(context, message.data);
    }
  }

  Future forgroundMessage() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
}

//
// import 'dart:developer' as d;
// import 'dart:io';
// import 'dart:math';
//
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:vista_flicks/ui/screens/main/preview_and_detail/detail/detail_page.dart';
// import 'package:vista_flicks/ui/screens/main/reel/reel_screen.dart';
//
// class NotificationServices {
//   //initialising firebase message plugin
//   FirebaseMessaging messaging = FirebaseMessaging.instance;
//
//   //initialising firebase message plugin
//   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//
//   //function to initialise flutter local notification plugin to show notifications for android when app is active
//   void initLocalNotifications(
//       BuildContext context, RemoteMessage message) async {
//     var androidInitializationSettings =
//         const AndroidInitializationSettings('@mipmap/ic_launcher');
//     var iosInitializationSettings = const DarwinInitializationSettings(
//       defaultPresentAlert: true,
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestCriticalPermission: true,
//       requestSoundPermission: true,
//       requestProvisionalPermission: true,
//       defaultPresentBanner: true,
//       defaultPresentSound: true,
//     );
//
//     var initializationSetting = InitializationSettings(
//         android: androidInitializationSettings, iOS: iosInitializationSettings);
//
//     await _flutterLocalNotificationsPlugin.initialize(initializationSetting,
//         onDidReceiveNotificationResponse: (payload) {
//       // handle interaction when app is active for android
//       handleMessage(context, message);
//     });
//   }
//
//   void firebaseInit(BuildContext context) {
//     FirebaseMessaging.onMessage.listen((message) {
//       print('Got a message whilst in the foreground!');
//
//       RemoteNotification? notification = message.notification;
//       AndroidNotification? android = message.notification?.android;
//       var data = message.data;
//
//       if (kDebugMode) {
//         d.log("fsfdsfsdfsdf $message");
//       }
//
//       if (Platform.isIOS) {
//         forgroundMessage();
//       }
//
//       if (Platform.isAndroid) {
//         initLocalNotifications(context, message);
//         showNotification(message);
//       }
//     });
//   }
//
//   void requestNotificationPermission() async {
//     await Permission.notification.request();
//
//     NotificationSettings settings = await messaging.requestPermission(
//       alert: true,
//       announcement: true,
//       badge: true,
//       carPlay: true,
//       criticalAlert: true,
//       provisional: true,
//       sound: true,
//     );
//
//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       if (kDebugMode) {
//         print('user granted permission');
//       }
//     } else if (settings.authorizationStatus ==
//         AuthorizationStatus.provisional) {
//       if (kDebugMode) {
//         print('user granted provisional permission');
//       }
//     } else {
//       //appsetting.AppSettings.openNotificationSettings();
//       if (kDebugMode) {
//         print('user denied permission');
//       }
//     }
//   }
//
//   // function to show visible notification when app is active
//   Future<void> showNotification(RemoteMessage message) async {
//     AndroidNotificationChannel channel = const AndroidNotificationChannel(
//       "notification",
//       "notification",
//       importance: Importance.high,
//       showBadge: true,
//       playSound: true,
//     );
//
//     AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails(
//             channel.id.toString(), channel.name.toString(),
//             channelDescription: 'your channel description',
//             importance: Importance.high,
//             priority: Priority.high,
//             playSound: true,
//             ticker: 'ticker',
//             sound: channel.sound
//             //     sound: RawResourceAndroidNotificationSound('jetsons_doorbell')
//             //  icon: largeIconPath
//             );
//
//     const DarwinNotificationDetails darwinNotificationDetails =
//         DarwinNotificationDetails(
//       presentBanner: true,
//       presentAlert: true,
//       presentBadge: true,
//       presentSound: true,
//     );
//
//     NotificationDetails notificationDetails = NotificationDetails(
//         android: androidNotificationDetails, iOS: darwinNotificationDetails);
//
//     Future.delayed(Duration.zero, () {
//       _flutterLocalNotificationsPlugin.show(
//         Random().nextInt(100000),
//         message.notification!.title.toString(),
//         message.notification!.body.toString(),
//         notificationDetails,
//       );
//     });
//   }
//
//   //function to get device token on which we will send the notifications
//   Future<String> getDeviceToken() async {
//     String? token = await messaging.getToken();
//     print("Device Token is $token");
//     return token!;
//   }
//
//   void isTokenRefresh() async {
//     messaging.onTokenRefresh.listen((event) {
//       event.toString();
//       if (kDebugMode) {
//         print('refresh');
//       }
//     });
//   }
//
//   //handle tap on notification when app is in background or terminated
//   Future<void> setupInteractMessage(BuildContext context) async {
//     // when app is terminated
//     RemoteMessage? initialMessage =
//         await FirebaseMessaging.instance.getInitialMessage();
//
//     if (initialMessage != null) {
//       // showColoredSnakeBar(Get.context!,
//       //     color: Colors.green, msg: "Please wait ....");
//       // // _myConfig.toast(msg: "Please Wait While We fatching Categories data.");
//
//       Future.delayed(const Duration(seconds: 5), () {
//         handleMessage(context, initialMessage);
//       });
//     }
//
//     //when app ins background
//     FirebaseMessaging.onMessageOpenedApp.listen((event) {
//       handleMessage(context, event);
//     });
//   }
//
//   String _parseRemoteData(Map<String, dynamic>? data) {
//     String payload = '';
//     print("fsdfsfsdffd $data");
//     if (data != null) {
//       payload = data.toString();
//     }
//
//     return payload.toString();
//   }
//
//   Map<String, dynamic> result = {};
//
//   void handleMessage(BuildContext context, RemoteMessage message) {
//     String payload = _parseRemoteData(message.data);
//     print('clicked notification =>  ${message.data}');
//     List<String> str =
//         payload.replaceAll("{", "").replaceAll("}", "").split(",");
//     for (int i = 0; i < str.length; i++) {
//       List<String> s = str[i].split(":");
//       result.putIfAbsent(s[0].trim(), () => s[1].trim());
//     }
//
//     if (payload.isNotEmpty) {
//       print("payload++ ${message.data["type"]}");
//       // "clicked notification =>  {reelId: 6808b3edeae587af6de2c6a9, contentId: 6808b3eceae587af6de2c69a, type: ADCAMPAIGN}"
//       // "clicked notification =>  {contentId: 6808b3eceae587af6de2c69a, type: ADCAMPAIGN}"
//       print("message.data['type'] ${message.data["type"]}");
//       print("message.data['reelId'] ${message.data["reelId"]}");
//       print("message.data['contentId'] ${message.data["contentId"]}");
//       if (message.data["type"] == "ADCAMPAIGN") {
//         print(
//             "=========================================================================");
//         print("message.data['reelId'] ${message.data["reelId"]}");
//         print("message.data['contentId'] ${message.data["contentId"]}");
//         if (message.data["reelId"] != null) {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => ReelScreen(
//                 reelId: message.data["reelId"],
//                 contentId: message.data["contentId"],
//               ),
//             ),
//           );
//         } else {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => DetailScreen(
//                 contentId: message.data["contentId"],
//               ),
//             ),
//           );
//         }
//       }
//
//       // if (message.data["type"] == 'WINNER-PUBLISH') {
//       //   Get.to(
//       //     WinnerDetailPage(
//       //       eventId: int.parse(message.data["event_id"]) ?? 0,
//       //       isFromScreen: 2,
//       //     ),
//       //   );
//       // } else if (message.data["type"] == 'EVENT-CREATE') {
//       //   Get.to(WinnerDetailPage(
//       //       eventId: int.parse(message.data["event_id"]) ?? 0,
//       //       isFromScreen: 1));
//       // } else if (message.data["type"] == 'HANDOVER') {
//       //   Get.to(WinnerDetailPage(
//       //       eventId: int.parse(message.data["event_id"]) ?? 0,
//       //       isFromScreen: 2));
//       // } else {}
//     }
//     throw ("Payload is Empty");
//   }
//
//   Future forgroundMessage() async {
//     await FirebaseMessaging.instance
//         .setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//   }
// }
