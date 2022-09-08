import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/todos.dart';
import '../entities/user.dart';

abstract class TodosRepository {
  Future<Either<Failure, List<Todos>>> getTodos();
  Future<Either<Failure, List<User>>> getUsers();
}
