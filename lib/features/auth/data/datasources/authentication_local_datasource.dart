import 'package:d_box/core/error/exceptions.dart';
import 'package:d_box/core/models/wallet_credential.dart';
import 'package:d_box/core/services/asymmetic_encryption.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:pinenacl/api/authenticated_encryption.dart';
import '../../../../core/constants/local_storage_path.dart';
import '../../../../core/services/secure_storage.dart';
import '../../../../generated/locale_keys.g.dart';

abstract class AuthenticationLocalDataSource {
  Future<bool> saveCredential({required WalletCredential credential});
  Future<bool> saveIpfsCredential({required String ipfsCredential});
}

@LazySingleton(as: AuthenticationLocalDataSource)
class AuthenticationLocalDataSourceImpl extends AuthenticationLocalDataSource {
  final SecureStorage secureStorage;
  final AsymmetricEncryption asymmetricEncryption;
  AuthenticationLocalDataSourceImpl(
      this.asymmetricEncryption, this.secureStorage);
  @override
  Future<bool> saveCredential({required WalletCredential credential}) async {
    try {
      await secureStorage.writeSecureData(
          LocalStoragePath.walletCredential, credential);
      return true;
    } on PlatformException catch (e) {
      String? message = e.message;
      message ??= LocaleKeys.errorMessages_saveCredential.tr();
      throw CacheException(message);
    }
  }

  @override
  Future<bool> saveIpfsCredential({required String ipfsCredential}) async {
    try {
      PrivateKey ipfsKey = asymmetricEncryption
          .generatePrivateKeyFromWalletPrivate(LocalStoragePath.ipfsCredential);
      String encodeData = ipfsKey.encode();
      await secureStorage.writeSecureData(
          LocalStoragePath.ipfsCredential, encodeData);
      return true;
    } on PlatformException catch (e) {
      String? message = e.message;
      message ??= LocaleKeys.errorMessages_saveIpfsCredential.tr();
      throw CacheException(message);
    } catch (e) {
      throw CacheException(e.toString());
    }
  }
}
