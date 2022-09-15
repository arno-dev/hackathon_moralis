import 'package:d_box/features/home/data/models/alerts_model.dart';
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
  Future<Either<Failure, List<ImagesFromLink>>> getRecents() async {
    try {
      final wallet = await dboxLocalDataSource.readWalletCredential();
      late String address;
      if (wallet != null) {
        address = wallet.address;
      } else {
        return Left(ServerFailure(LocaleKeys.somethingWrong.tr()));
      }
      final data = await dboxRemoteDataSource.getRecents(address);
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
      String destinationPublicAndIpfsKey,
      String path) async {
    try {
      List<String> userShare = destinationPublicAndIpfsKey.split("-+-");
      if (userShare.length != 2) {
        return const Left(
            ServerFailure("Your content or key is not availble!"));
      }
      String dest = userShare[0];
      String encryptIpfsKey = userShare[1];
      String? myIpfsCredentialString = await dboxLocalDataSource.readIpfsKey();
      // this is a ipfs public key of destination
      PublicKey destinationPublicKey = PublicKey.decode(encryptIpfsKey);

      List<ImageParam>? imageParam = uploadImageParam.images;
      if (imageParam == null || myIpfsCredentialString == null) {
        return const Left(
            ServerFailure("Your content or key is not availble!"));
      }
      // this is the private ipfs key
      PrivateKey privateKey = PrivateKey.decode(myIpfsCredentialString);
      List<ImageParam?> encryptImages = [];
      encryptImages = imageParam.map((data) {
        if (data.content == null) {
          return null;
        }
        // in order to encrypt the file you have to use you ipfs private key
        // and ipfs public key of user who you gonna send the content to.
        String encryptContent = dboxLocalDataSource.encryptFileContent(
            data.content!, privateKey, destinationPublicKey);
        return ImageParam(
            content: encryptContent, path: path != "" ? path : data.path);
      }).toList();
      List<ImageParam>? newImageParam = [];
      for (ImageParam? encryptImage in encryptImages) {
        if (encryptImage != null) {
          newImageParam.add(encryptImage);
        }
      }

      final wallet = await dboxLocalDataSource.readWalletCredential();
      String origin = "";
      if (wallet != null) {
        origin = wallet.address;
      }

      final data =
          await dboxRemoteDataSource.postSaveImages(uploadImageParam.copyWith(
              // origin is a wallet address
              origin: origin,
              // destination is a wallet address of a user who gonna share content
              dest: dest,
              images: newImageParam,
              // encryptIpfsKey is your ipfs public key
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
  Future<Either<Failure, List<AlertsModel>>> getAlerts() async {
    try {
      final wallet = await dboxLocalDataSource.readWalletCredential();
      String address = "";
      if (wallet != null) {
        address = wallet.address;
      }
      final data = await dboxRemoteDataSource.getAlerts(address);
      return Right(data);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> previewFile(
      ImageParam data, String destinationPublic) async {
    try {
      // your ipfs private key
      String? myIpfsCredential = await dboxLocalDataSource.readIpfsKey();
      if (myIpfsCredential == null) return const Right(false);
      // convert string ipfs private to privateKey type
      PrivateKey privateKey = PrivateKey.decode(myIpfsCredential);
      // destination's ipfs public key
      PublicKey destinationPublicKey = PublicKey.decode(destinationPublic);

      final response = await dboxLocalDataSource.previewFile(
        data,
        privateKey,
        destinationPublicKey,
      );
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message.toString()));
    } catch (e) {
      return Left(ServerFailure(LocaleKeys.somethingWrong.tr()));
    }
  }
}
