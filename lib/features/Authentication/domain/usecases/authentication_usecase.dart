import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/authentication_repositories.dart';

@lazySingleton

class GetMnemonicUseCase implements UseCase<List<String>, NoParams> {
  final AuthenticationRepository authenticationRepository;

  GetMnemonicUseCase({required this.authenticationRepository});
  @override
  Future<Either<Failure, List<String>>> call(NoParams params) async {
    return await authenticationRepository.getMnemonic();
  }
  
}