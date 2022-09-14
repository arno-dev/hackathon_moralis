import 'dart:convert';
import 'dart:core';

import 'package:d_box/core/constants/local_storage_path.dart';
import 'package:d_box/core/services/asymmetic_encryption.dart';
import 'package:d_box/core/services/file_handler.dart';
import 'package:d_box/core/services/secure_storage.dart';
import 'package:d_box/features/home/data/models/params/upload_image_param/image_param.dart';
import 'package:injectable/injectable.dart';
import 'package:pinenacl/x25519.dart';

abstract class DboxLocalDataSource {
  Future<bool> previewFile(
      ImageParam data,
      AsymmetricPrivateKey sourcePrivateKey,
      AsymmetricPublicKey destinationPublic);
  Future<List<ImageParam>> pickFile();
  Future<PrivateKey?> readIpfsKey();
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
  Future<List<ImageParam>> pickFile({List<String>? allowedExtensions}) async {
    return await fileHandler.getMultiFiles(
        allowedExtensions: allowedExtensions);
  }

  @override
  String encryptFileContent(
      String content,
      AsymmetricPrivateKey sourcePrivateKey,
      AsymmetricPublicKey destinationPublic) {
    return asymmetricEncryption.encryptData(
        content, sourcePrivateKey, destinationPublic);
  }

  @override
  String decryptFileContent(
      String encryptcontent,
      AsymmetricPrivateKey sourcePrivateKey,
      AsymmetricPublicKey destinationPublic) {
    return asymmetricEncryption.decryptData(
        encryptcontent, sourcePrivateKey, destinationPublic);
  }

  @override
  Future<PrivateKey?> readIpfsKey() async {
    String? rawData =
        await secureStorage.readSecureData(LocalStoragePath.ipfsCredential);
    if (rawData != null) {
      PrivateKey? ipfsKey = jsonDecode(rawData);
      return ipfsKey;
    }
    return null;
  }

  @override
  Future<bool> previewFile(
      ImageParam data,
      AsymmetricPrivateKey sourcePrivateKey,
      AsymmetricPublicKey destinationPublic) async {
    if (data.content == null || data.path == null) {
      return false;
    } else {
      try {
        String base64String = asymmetricEncryption.decryptData(
            data.content!, sourcePrivateKey, destinationPublic);
        await fileHandler.getPreviewFile(base64String, data.path!);
        return true;
      } catch (e) {
        return false;
      }
    }
  }
}
