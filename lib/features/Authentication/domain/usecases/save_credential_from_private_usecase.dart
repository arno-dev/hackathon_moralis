import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/authentication_repositories.dart';

@lazySingleton

class SaveCredentialFromPrivateKeyUseCase implements UseCase<bool, String> {
  final AuthenticationRepository authenticationRepository;

  SaveCredentialFromPrivateKeyUseCase({required this.authenticationRepository});
  @override
  Future<Either<Failure, bool>> call(String params) async {
    return  authenticationRepository.verifyCredentialFromPrivateKey(privateKey: params);
  }
  
}