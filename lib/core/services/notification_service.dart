import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../config/DI/configure_dependencies.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final FirebaseMessaging messaging;

  NotificationService(this.flutterLocalNotificationsPlugin, this.messaging);

  void registerNotification() async {
    FirebaseMessaging.onBackgroundMessage(messageHandler);
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      if (defaultTargetPlatform == TargetPlatform.android) {}
      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
          final token = await messaging.getToken();
          print("register toke: $token");
          break;
        case TargetPlatform.iOS:
          final apnToken = await messaging.getAPNSToken();
          print("register apnToken: $apnToken");
          break;
        default:
      }

      // For handling the received notifications
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        showLocalNotification(
            body: message.notification?.body ?? "",
            title: message.notification?.title ?? "",
            payload: convertPayload(message.data));
      });

      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        print('Message clicked!');
      });
    } else {
      print('User declined or has not accepted permission');
    }
  }

  Future<void> initializePlatformNotifications() async {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = const IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: _onSelectNotification);
    registerNotification();
  }

  Future<void> showLocalNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    final platformChannelSpecifics = await _notificationDetails();
    await flutterLocalNotificationsPlugin.show(
      UniqueKey().hashCode,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  String convertPayload(Map<String, dynamic> payload) {
    return jsonEncode(payload);
  }

  void _onSelectNotification(String? payload) {
    if (payload != null) {
      debugPrint(jsonDecode(payload));
    }
  }

  Future<NotificationDetails> _notificationDetails() async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        const AndroidNotificationDetails(
      'd-box-channel',
      'channel name',
      groupKey: 'com.example.flutter_push_notifications',
      channelDescription: 'channel description',
      importance: Importance.max,
      priority: Priority.max,
    );

    IOSNotificationDetails iosNotificationDetails =
        const IOSNotificationDetails();

    final details =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {
      _onSelectNotification(details.payload);
    }

    NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iosNotificationDetails);

    return platformChannelSpecifics;
  }
}
