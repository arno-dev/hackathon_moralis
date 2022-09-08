import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/todos_repository.dart';

@lazySingleton
class GetUsersUseCase implements UseCase<List<User>, NoParams> {
  final TodosRepository todosRepository;
  GetUsersUseCase(this.todosRepository);

  @override
  Future<Either<Failure, List<User>>> call(NoParams noParams) async {
    return await todosRepository.getUsers();
  }
}
