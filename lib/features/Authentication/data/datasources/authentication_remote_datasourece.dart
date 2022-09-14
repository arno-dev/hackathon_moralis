import 'package:easy_localization/easy_localization.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/services/wallet_service.dart';
import '../../../../generated/locale_keys.g.dart';

abstract class AuthenticationRemoteDataSource{
 List<String> getMnemonic();
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
  }}