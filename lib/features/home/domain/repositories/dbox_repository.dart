import 'package:d_box/features/home/data/models/params/upload_image_param/image_param.dart';
import 'package:d_box/features/home/data/models/params/upload_image_param/upload_image_param.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pinenacl/x25519.dart';

import '../../../../core/error/failures.dart';
import '../../data/models/save_images_model.dart';
import '../entities/images_from_link.dart';

abstract class DboxRepository {
  Future<Either<Failure, ImagesFromLink>> getImagesFromLink(String link);
  Future<Either<Failure, List<ImagesFromLink>>> getRecents(String recents);
  Future<Either<Failure, SaveImagesModel>> postSaveImages(
      UploadImageParam uploadImageParam, AsymmetricPublicKey destinationPublic);
  Future<Either<Failure, bool>> previewFile(
    ImageParam data,
    AsymmetricPublicKey destinationPublic,
  );
  Future<Either<Failure, List<ImageParam>>> pickImages();
  Future<Either<Failure, bool>> initializeFirebaseMessaging(
      {void Function(RemoteMessage)? onMessageOpenedApp,
      void Function(String?)? onSelectNotification});
}
