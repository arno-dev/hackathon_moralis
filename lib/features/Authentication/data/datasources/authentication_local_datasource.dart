import 'package:injectable/injectable.dart';
import '../../../../core/constants/local_storage_path.dart';
import '../../../../core/services/secure_storage.dart';
abstract class AuthenticationLocalDataSource{
 Future<bool> saveCredential({required String credential} );
}

@LazySingleton(as: AuthenticationLocalDataSource)

class AuthenticationLocalDataSourceImpl extends AuthenticationLocalDataSource {
  final SecureStorage secureStorage;
  AuthenticationLocalDataSourceImpl({required this.secureStorage});
  @override
  Future<bool> saveCredential({required String credential}) async {
    try {
      await secureStorage.writeSecureData(LocalStoragePath.walletCredential, credential);
      return  true;
    } catch (e) {
      return false;
    }
  }


  }