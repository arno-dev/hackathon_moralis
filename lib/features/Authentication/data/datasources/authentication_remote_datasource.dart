import 'package:easy_localization/easy_localization.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/models/wallet_credential.dart';
import '../../../../core/services/wallet_service.dart';
import '../../../../generated/locale_keys.g.dart';

abstract class AuthenticationRemoteDataSource{
 List<String> getMnemonic();
 WalletCredential getCredential({required List<String> mnemonic} );
}

@LazySingleton(as: AuthenticationRemoteDataSource)

class AuthenticationRemoteDataSourceImpl extends AuthenticationRemoteDataSource {
  final WalletService walletService;

  AuthenticationRemoteDataSourceImpl({required this.walletService});
  @override
  List<String> getMnemonic()  {
    try {
      final data = walletService.generateMnemonic();
       List<String> res = data.split(" ");
      return res;
    }  catch (e) {
      throw ServerException(LocaleKeys.somethingWrong.tr());
    }
  }
  
  @override
  WalletCredential getCredential({required List<String> mnemonic})  {
  try {
    final convertData = mnemonic.join(" ");
      final data = walletService.getCredential(convertData);
      return data;
    }  catch (e) {
      throw ServerException(LocaleKeys.somethingWrong.tr());
    }
  }}