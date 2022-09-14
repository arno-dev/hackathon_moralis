import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/authentication_repositories.dart';

@lazySingleton

class SaveCredentialUseCase implements UseCase<bool, List<String>> {
  final AuthenticationRepository authenticationRepository;

  SaveCredentialUseCase({required this.authenticationRepository});
  @override
  Future<Either<Failure, bool>> call(List<String> params) async {
    return  authenticationRepository.verifyCredential(mnemonic: params);
  }
  
}