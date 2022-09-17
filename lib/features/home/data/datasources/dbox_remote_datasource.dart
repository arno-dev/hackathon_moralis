import 'dart:convert';
import 'dart:core';

import 'package:d_box/core/services/push_notification_service.dart';
import 'package:d_box/core/services/file_handler.dart';
import 'package:d_box/features/home/data/models/notification_payload_model.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/services/api_client.dart';
import '../../../../core/util/response_helper.dart';
import '../../../../generated/locale_keys.g.dart';
import '../models/alerts_model.dart';
import '../models/images_from_link_model.dart';
import '../models/params/firebase_param/firebase_token_param.dart';
import '../models/params/upload_image_param/upload_image_param.dart';
import '../models/save_images_model.dart';

abstract class DboxRemoteDataSource {
  Future<ImagesFromLinkModel> getImageFromLink(String link);
  Future<List<ImagesFromLinkModel>> getRecents(String recents);
  Future<SaveImagesModel> postSaveImages(UploadImageParam uploadImageParam);
  Future<String?> initializeFirebaseMessaging(
      {void Function(RemoteMessage)? onMessageOpenedApp,
      void Function(NotificationPayloadModel?)? onSelectNotification});
  Future<List<AlertsModel>> getAlerts(String address);
  Future<bool> saveFirebaseToken(FirebaseTokenParam firebaseTokenParam);
}

@LazySingleton(as: DboxRemoteDataSource)
class DboxRemoteDataSourceImpl extends DboxRemoteDataSource {
  final ApiClient apiClient;
  final FileHandler fileHandler;
  final PushNotificationService notificationService;

  DboxRemoteDataSourceImpl(
      this.apiClient, this.fileHandler, this.notificationService);

  @override
  Future<ImagesFromLinkModel> getImageFromLink(String link) async {
    try {
      return await apiClient.getImagesFromLink(link);
    } on DioError catch (e) {
      throw ResponseHelper.returnResponse(e);
    } catch (e) {
      throw ServerException(LocaleKeys.errorMessages_getImagesFromLink.tr());
    }
  }

  @override
  Future<List<ImagesFromLinkModel>> getRecents(String recents) async {
    try {
      return await apiClient.getRecents(recents);
    } on DioError catch (e) {
      throw ResponseHelper.returnResponse(e);
    } catch (e) {
      throw ServerException(LocaleKeys.errorMessages_getRecent.tr());
    }
  }

  @override
  Future<SaveImagesModel> postSaveImages(
      UploadImageParam uploadImageParam) async {
    Map<String, dynamic> body = uploadImageParam.toMap();
    try {
      return await apiClient.postSaveImages(body);
    } catch (e) {
      throw ServerException(LocaleKeys.errorMessages_saveImages.tr());
    }
  }

  @override
  Future<String?> initializeFirebaseMessaging(
      {void Function(RemoteMessage)? onMessageOpenedApp,
      void Function(NotificationPayloadModel?)? onSelectNotification}) async {
    try {
      return await notificationService.initializePlatformNotifications(
        onMessageOpenedApp: onMessageOpenedApp,
        onSelectNotification: (String? stringPayload) {
          if (stringPayload != null) {
            Map<String, dynamic> payload = jsonDecode(stringPayload);
            if (payload.isEmpty) {
              onSelectNotification!(null);
            } else {
              onSelectNotification!(NotificationPayloadModel.fromJson(payload));
            }
          } else {
            onSelectNotification!(null);
          }
        },
      );
    } catch (e) {
      throw ServerException(LocaleKeys.errorMessages_initializeFirebase.tr());
    }
  }

  @override
  Future<List<AlertsModel>> getAlerts(String address) async {
    try {
      return await apiClient.getAlerts(address);
    } on DioError catch (e) {
      throw ResponseHelper.returnResponse(e);
    } catch (e) {
      throw ServerException(LocaleKeys.errorMessages_getAlerts.tr());
    }
  }

  @override
  Future<bool> saveFirebaseToken(FirebaseTokenParam firebaseTokenParam) async {
    try {
      await apiClient.saveFirebaseToken(firebaseTokenParam.toMap());
      return true;
    } on DioError catch (e) {
      throw ResponseHelper.returnResponse(e);
    } catch (e) {
      throw ServerException(LocaleKeys.errorMessages_saveFirebase.tr());
    }
  }
}
