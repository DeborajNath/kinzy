// import 'dart:convert';
// import 'dart:developer';

// import 'package:authentication_firebase/main_screens/signup_page.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Future<void> handleBackgroundMessage(RemoteMessage message) async {
//   log(message.notification!.title.toString());
//   log(message.notification!.body.toString());
//   log(message.data.toString());
// }

// void handleMessage(RemoteMessage? message, BuildContext context) {
//   if (message == null) return;
//   Navigator.push(
//     context,
//     MaterialPageRoute(builder: (_) => const SignupScreen()),
//   );
// }

// Future initPushNotifications(BuildContext context) async {
//   await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
//     alert: true,
//     badge: true,
//     sound: true,
//   );
//   FirebaseMessaging.instance.getInitialMessage().then((message) {
//     handleMessage(message, context);
//   });
//   FirebaseMessaging.onMessageOpenedApp.listen((message) {
//     handleMessage(message, context);
//   });
//   FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
// }

// class FirebaseApi {
//   final _firebaseMessaging = FirebaseMessaging.instance;
//   final androidChannel = const AndroidNotificationChannel(
//     "high_importance_channel",
//     "High Important Notification",
//     description: "This Channel is used for notification",
//     importance: Importance.defaultImportance,
//   );
//   final localNotification = FlutterLocalNotificationsPlugin();
//   Future<void> initNotification() async {
//     await _firebaseMessaging.requestPermission();
//     final fcmToken = await _firebaseMessaging.getToken();
//     log(fcmToken.toString());
//     FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
//     FirebaseMessaging.onMessage.listen((message) {
//       final notification = message.notification;
//       if (notification == null) return;
//       localNotification.show(
//         notification.hashCode,
//         notification.title,
//         notification.body,
//         NotificationDetails(
//           android: AndroidNotificationDetails(
//             androidChannel.id,
//             androidChannel.name,
//             channelDescription: androidChannel.description,
//             icon: '@drawable/ic_launcher',
//           ),
//         ),
//         payload: jsonEncode(message.toMap()),
//       );
//     });
//   }

//   // Future initLocalNotifications() async {
//   //   const android = AndroidInitializationSettings(
//   //     '@drawable/ic_launcher',
//   //   );
//   // }
// }
