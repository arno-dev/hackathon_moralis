import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/authentication_repositories.dart';
import '../datasources/authentication_remote_datasourece.dart';

@LazySingleton(as: AuthenticationRepository)

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final AuthenticationRemoteDataSource authenticationRemoteDataSource;

  AuthenticationRepositoryImpl({required this.authenticationRemoteDataSource});

  @override
  Future<Either<Failure, List<String>>> getMnemonic() async {
    try {
      final res = await authenticationRemoteDataSource.getMnemonic();
     
      return Right(res);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message.toString()));
    }
  }
  
}