import 'dart:convert';

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

  AuthenticationRepositoryImpl({required this.authenticationRemoteDataSource, required this.authenticationLocalDataSource});

  @override
  Future<Either<Failure, List<String>>> getMnemonic() async {
      final res =  authenticationRemoteDataSource.getMnemonic();
      return Right(res);
  }
  
  @override
  Future<Either<Failure, bool>> verifyCredential({required List<String> mnemonic})async  {
   try {
      WalletCredential res =   authenticationRemoteDataSource.getCredential(mnemonic: mnemonic);
      final saveCredential = await authenticationLocalDataSource.saveCredential(credential: jsonEncode(res.toJson()));
      return  Right(saveCredential);
   }  on ServerException catch (e) {
     return Left(ServerFailure( e.toString()));
   }
  }
  
}