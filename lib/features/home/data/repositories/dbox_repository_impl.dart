import 'package:d_box/features/home/data/datasources/dbox_local_datasource.dart';
import 'package:d_box/features/home/data/models/params/upload_image_param/image_param.dart';
import 'package:d_box/features/home/data/models/params/upload_image_param/upload_image_param.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:injectable/injectable.dart';
import 'package:pinenacl/x25519.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../domain/entities/images_from_link.dart';
import '../../domain/repositories/dbox_repository.dart';
import '../datasources/dbox_remote_datasource.dart';
import '../models/save_images_model.dart';

@LazySingleton(as: DboxRepository)
class DboxRepositoryImpl implements DboxRepository {
  final DboxRemoteDataSource dboxRemoteDataSource;
  final DboxLocalDataSource dboxLocalDataSource;

  DboxRepositoryImpl(this.dboxRemoteDataSource, this.dboxLocalDataSource);
  @override
  Future<Either<Failure, ImagesFromLink>> getImagesFromLink(String link) async {
    try {
      final data = await dboxRemoteDataSource.getImageFromLink(link);
      return Right(data);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ImagesFromLink>>> getRecents(
      String recents) async {
    try {
      final data = await dboxRemoteDataSource.getRecents(recents);
      return Right(data);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ImageParam>>> pickImages() async {
    try {
      final data = await dboxLocalDataSource.pickFile();
      return Right(data);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message.toString()));
    }
  }

  @override
  Future<Either<Failure, SaveImagesModel>> postSaveImages(
      UploadImageParam uploadImageParam, String destinationPublic) async {
    try {
      String? myIpfsCredentialString = await dboxLocalDataSource.readIpfsKey();
      PublicKey destinationPublicKey = PublicKey.decode(destinationPublic);

      List<ImageParam>? imageParam = uploadImageParam.images;
      if (imageParam == null || myIpfsCredentialString == null) {
        return const Left(
            ServerFailure("Your content or key is not availble!"));
      }
      PrivateKey privateKey = PrivateKey.decode(myIpfsCredentialString);
      List<ImageParam?> encryptImages = [];
      encryptImages = imageParam.map((data) {
        if (data.content == null) {
          return null;
        }
        String encryptContent = dboxLocalDataSource.encryptFileContent(
            data.content!, privateKey, destinationPublicKey);
        return ImageParam(content: encryptContent, path: data.path);
      }).toList();
      List<ImageParam>? newImageParam = [];
      for (ImageParam? encryptImage in encryptImages) {
        if (encryptImage != null) {
          newImageParam.add(encryptImage);
        }
      }

      final data = await dboxRemoteDataSource.postSaveImages(
          uploadImageParam.copyWith(
              origin: "0xFE2b19a3545f25420E3a5DAdf11b5582b5B3aBA8",
              dest: "0xFE2b19a3545f25420E3a5DAdf11b5582b5B3aBA8",
              images: newImageParam,
              encryptIpfsKey: privateKey.publicKey.encode()));
      return Right(data);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> initializeFirebaseMessaging(
      {void Function(RemoteMessage message)? onMessageOpenedApp,
      void Function(String? payload)? onSelectNotification}) async {
    try {
      final data = await dboxRemoteDataSource.initializeFirebaseMessaging(
        onMessageOpenedApp: onMessageOpenedApp,
        onSelectNotification: onSelectNotification,
      );
      return Right(data);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> previewFile(
      ImageParam data, String destinationPublic) async {
    try {
      String? myIpfsCredential = await dboxLocalDataSource.readIpfsKey();
      PublicKey destinationPublicKey = PublicKey.decode(destinationPublic);
      if (myIpfsCredential == null) return const Right(false);
      PrivateKey privateKey = PrivateKey.decode(myIpfsCredential);
      final response = await dboxLocalDataSource.previewFile(
          data, privateKey, destinationPublicKey);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message.toString()));
    } catch (e) {
      return Left(ServerFailure(LocaleKeys.somethingWrong.tr()));
    }
  }
}
