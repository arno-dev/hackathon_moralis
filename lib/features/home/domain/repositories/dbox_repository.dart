import 'package:d_box/core/constants/pick_file_type.dart';
import 'package:d_box/features/home/domain/entities/alerts.dart';
import 'package:d_box/features/home/data/models/params/upload_image_param/image_param.dart';
import 'package:d_box/features/home/data/models/params/upload_image_param/upload_image_param.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../../../core/error/failures.dart';
import '../../data/models/save_images_model.dart';
import '../entities/images_from_link.dart';
import '../entities/notification_payload.dart';

abstract class DboxRepository {
  Future<Either<Failure, ImagesFromLink>> getImagesFromLink(String link);
  Future<Either<Failure, List<ImagesFromLink>>> getRecents();
  Future<Either<Failure, SaveImagesModel>> postSaveImages(
      UploadImageParam uploadImageParam,
      String? destinationPublic,
      String path);
  Future<Either<Failure, bool>> previewFile(
    String url,
    String destinationPublic,
  );
  Future<Either<Failure, List<ImageParam>>> pickFiles(PickFileType pickFileType);
  Future<Either<Failure, bool>> initializeFirebaseMessaging(
      {void Function(RemoteMessage)? onMessageOpenedApp,
     void Function(NotificationPayload?)? onSelectNotification});
  Future<Either<Failure, List<Alerts>>> getAlerts();
  Future<Either<Failure, String>> getMyQrCode();
}
