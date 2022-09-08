import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/todos.dart';
import '../repositories/todos_repository.dart';

@lazySingleton
class GetTodosUseCase implements UseCase<List<Todos>, NoParams> {
  final TodosRepository todosRepository;
  GetTodosUseCase(this.todosRepository);

  @override
  Future<Either<Failure, List<Todos>>> call(NoParams noParams) async {
    return await todosRepository.getTodos();
  }
}
