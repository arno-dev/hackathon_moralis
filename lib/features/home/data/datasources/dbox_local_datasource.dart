import 'dart:core';

import 'package:d_box/core/constants/local_storage_path.dart';
import 'package:d_box/core/error/exceptions.dart';
import 'package:d_box/core/models/wallet_credential.dart';
import 'package:d_box/core/services/asymmetic_encryption.dart';
import 'package:d_box/core/services/file_handler.dart';
import 'package:d_box/core/services/secure_storage.dart';
import 'package:d_box/features/home/data/models/params/upload_image_param/image_param.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:injectable/injectable.dart';
import 'package:pinenacl/x25519.dart';

import '../../../../core/constants/pick_file_type.dart';
import '../../../../generated/locale_keys.g.dart';

abstract class DboxLocalDataSource {
  Future<bool> previewFile(String url, AsymmetricPrivateKey sourcePrivateKey,
      AsymmetricPublicKey destinationPublic);
  Future<List<ImageParam>> pickFile(PickFileType pickFileType);
  Future<String?> readIpfsKey();
  Future<WalletCredential?> readWalletCredential();
  String encryptFileContent(
      String content,
      AsymmetricPrivateKey sourcePrivateKey,
      AsymmetricPublicKey destinationPublic);
  String decryptFileContent(
      String encryptcontent,
      AsymmetricPrivateKey sourcePrivateKey,
      AsymmetricPublicKey destinationPublic);
}

@LazySingleton(as: DboxLocalDataSource)
class DboxLocalDataSourceImpl extends DboxLocalDataSource {
  final FileHandler fileHandler;
  final AsymmetricEncryption asymmetricEncryption;
  final SecureStorage secureStorage;

  DboxLocalDataSourceImpl(
    this.fileHandler,
    this.asymmetricEncryption,
    this.secureStorage,
  );

  @override
  Future<List<ImageParam>> pickFile(PickFileType pickFileType) async {
    try {
      switch (pickFileType) {
        case PickFileType.files:
          return await fileHandler.getMultiFiles();
        case PickFileType.photos:
          return await fileHandler.imagePickerHandler();
        case PickFileType.takePhoto:
          return await fileHandler.imagePickerHandler(isPhotos: false);
      }
    } catch (e) {
      throw CacheException(LocaleKeys.errorMessages_pickFile.tr());
    }
  }

  @override
  String encryptFileContent(
      String content,
      AsymmetricPrivateKey sourcePrivateKey,
      AsymmetricPublicKey destinationPublic) {
    try {
      return asymmetricEncryption.encryptData(
          content, sourcePrivateKey, destinationPublic);
    } catch (e) {
      throw CacheException(LocaleKeys.errorMessages_encryptFile.tr());
    }
  }

  @override
  String decryptFileContent(
      String encryptcontent,
      AsymmetricPrivateKey sourcePrivateKey,
      AsymmetricPublicKey destinationPublic) {
    try {
      return asymmetricEncryption.decryptData(
          encryptcontent, sourcePrivateKey, destinationPublic);
    } catch (e) {
      throw CacheException(LocaleKeys.errorMessages_decryptFile.tr());
    }
  }

  @override
  Future<String?> readIpfsKey() async {
    try {
      String? rawData = await secureStorage
          .readSecureData<String?>(LocalStoragePath.ipfsCredential);
      return rawData;
    } catch (e) {
      throw CacheException(LocaleKeys.errorMessages_readIpfs.tr());
    }
  }

  @override
  Future<WalletCredential?> readWalletCredential() async {
    try {
      Map<String, dynamic>? rawData =
          await secureStorage.readSecureData(LocalStoragePath.walletCredential);
      if (rawData != null) return WalletCredential.fromJson(rawData);
      return null;
    } catch (e) {
      throw CacheException(LocaleKeys.errorMessages_readWallet.tr());
    }
  }

  @override
  Future<bool> previewFile(String url, AsymmetricPrivateKey sourcePrivateKey,
      AsymmetricPublicKey destinationPublic) async {
    try {
      String content = await fileHandler.networkFileToBase64(url);
      String base64String = asymmetricEncryption.decryptData(
          content, sourcePrivateKey, destinationPublic);
      await fileHandler.getPreviewFile(base64String, url.split("/").last);
      return true;
    } catch (e) {
      throw CacheException(LocaleKeys.errorMessages_previewError.tr());
    }
  }
}
