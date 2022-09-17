import 'dart:convert';

import 'package:d_box/core/error/exceptions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import '../config/DI/configure_dependencies.dart';

@lazySingleton
class PushNotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final FirebaseMessaging messaging;

  PushNotificationService(this.flutterLocalNotificationsPlugin, this.messaging);

  Future<String?> _registerNotification(
    void Function(RemoteMessage)? onMessageOpenedApp,
  ) async {
    try {
      FirebaseMessaging.onBackgroundMessage(messageHandler);
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        provisional: false,
        sound: true,
      );
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        final token = await messaging.getToken();

        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          showLocalNotification(
              body: message.notification?.body ?? "",
              title: message.notification?.title ?? "",
              payload: _convertPayload(message.data));
        });

        FirebaseMessaging.onMessageOpenedApp.listen(onMessageOpenedApp);
        return token;
      } else {
        throw ServerException("User declined or has not accepted permission");
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<String?> initializePlatformNotifications( {
    void Function(RemoteMessage)? onMessageOpenedApp,
    void Function(String?)? onSelectNotification,
  }) async {
    try {
      var initializationSettingsAndroid =
          const AndroidInitializationSettings('app_icon');
      var initializationSettingsIOS = const IOSInitializationSettings();
      var initializationSettings = InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS);

      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestPermission();
      flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onSelectNotification: onSelectNotification);

      final details = await flutterLocalNotificationsPlugin
          .getNotificationAppLaunchDetails();
      if (details != null && details.didNotificationLaunchApp) {
        onSelectNotification!(details.payload);
      }
      final token = await _registerNotification(onMessageOpenedApp);
      return token;
    } catch (_) {
      rethrow;
    }
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

  String _convertPayload(Map<String, dynamic> payload) {
    return jsonEncode(payload);
  }

  Future<NotificationDetails> _notificationDetails() async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        const AndroidNotificationDetails(
      'd-box-channel',
      'D-Box',
      channelDescription: 'channel description',
      importance: Importance.max,
      priority: Priority.max,
    );

    IOSNotificationDetails iosNotificationDetails =
        const IOSNotificationDetails();

    NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iosNotificationDetails);

    return platformChannelSpecifics;
  }
}
