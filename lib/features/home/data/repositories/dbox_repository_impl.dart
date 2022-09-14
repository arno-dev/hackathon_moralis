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
      UploadImageParam uploadImageParam,
      AsymmetricPublicKey destinationPublic) async {
    try {
      PrivateKey? myIpfsCredential = await dboxLocalDataSource.readIpfsKey();
      List<ImageParam>? imageParam = uploadImageParam.images;
      if (imageParam == null || myIpfsCredential == null) {
        return const Left(
            ServerFailure("Your content or key is not availble!"));
      }
      List<ImageParam?> encryptImages = imageParam.map((data) {
        if (data.content == null) {
          return null;
        }
        String encryptContent = dboxLocalDataSource.encryptFileContent(
            data.content!, myIpfsCredential, destinationPublic);
        return ImageParam(content: encryptContent, path: data.path);
      }).toList();
      List<ImageParam>? newImageParam = [];
      for (ImageParam? encryptImage in encryptImages) {
        if (encryptImage == null) {
          newImageParam.add(encryptImage!);
        }
      }

      final data = await dboxRemoteDataSource
          .postSaveImages(uploadImageParam.copyWith(images: newImageParam));
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
      ImageParam data, AsymmetricPublicKey destinationPublic) async {
    try {
      PrivateKey? myIpfsCredential = await dboxLocalDataSource.readIpfsKey();
      if (myIpfsCredential == null) return const Right(false);
      final response = await dboxLocalDataSource.previewFile(
          data, myIpfsCredential, destinationPublic);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message.toString()));
    } catch (e) {
      return Left(ServerFailure(LocaleKeys.somethingWrong.tr()));
    }
  }
}
