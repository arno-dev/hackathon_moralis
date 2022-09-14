import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import '../../middleware/interceptors.dart';
import 'package:http/http.dart' as http;

@module
abstract class AppModule {
  @lazySingleton
  Dio dio(@Named('appInterceptors') AppInterceptors appInterceptors) {
    final dio = Dio();
    dio.interceptors.add(appInterceptors);
    return dio;
  }

  @lazySingleton
  FlutterSecureStorage get flutterSecureStorage => const FlutterSecureStorage(
        aOptions: AndroidOptions(encryptedSharedPreferences: true),
      );

  @lazySingleton
  FilePicker get filePicker => FilePicker.platform;

  @lazySingleton
  http.Client get client => http.Client();

  @injectable
  FlutterLocalNotificationsPlugin get flutterLocalNotificationsPlugin =>
      FlutterLocalNotificationsPlugin();

  @injectable
  FirebaseMessaging get firebaseMessaging => FirebaseMessaging.instance;
}
