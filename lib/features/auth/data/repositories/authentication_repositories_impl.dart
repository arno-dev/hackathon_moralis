import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/models/wallet_credential.dart';
import '../../domain/repositories/authentication_repositories.dart';
import '../datasources/authentication_local_datasource.dart';
import '../datasources/authentication_remote_datasource.dart';

@LazySingleton(as: AuthenticationRepository)
class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final AuthenticationRemoteDataSource authenticationRemoteDataSource;
  final AuthenticationLocalDataSource authenticationLocalDataSource;

  AuthenticationRepositoryImpl(
      {required this.authenticationRemoteDataSource,
      required this.authenticationLocalDataSource});

  @override
  Future<Either<Failure, List<String>>> getMnemonic() async {
    try {
      final res = authenticationRemoteDataSource.getMnemonic();
      return Right(res);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  Future<bool> _saveCredential(WalletCredential res) async {
    final saveCredential =
        await authenticationLocalDataSource.saveCredential(credential: res);
    final saveIpfsCredential = await authenticationLocalDataSource
        .saveIpfsCredential(ipfsCredential: res.privateKey);
    return (saveCredential && saveIpfsCredential);
  }

  @override
  Future<Either<Failure, bool>> verifyCredential(
      {required List<String> mnemonic}) async {
    try {
      WalletCredential res =
          authenticationRemoteDataSource.getCredential(mnemonic: mnemonic);
      final response = await _saveCredential(res);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      throw CacheFailure(e.message);
    }
  }

  @override
  Future<Either<Failure, bool>> verifyCredentialFromPrivateKey(
      {required String privateKey}) async {
    try {
      WalletCredential res = authenticationRemoteDataSource
          .getCredentialFromPrivate(privateKey: privateKey);
      final response = await _saveCredential(res);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      throw CacheFailure(e.message);
    }
  }
}
