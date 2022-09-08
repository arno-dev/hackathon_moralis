import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/todos.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/todos_repository.dart';
import '../datasources/todos_remote_datasource.dart';

@LazySingleton(as: TodosRepository)
class TodosRepositoryImpl implements TodosRepository {
  final TodosRemoteDatasource todosRemoteDatasource;

  TodosRepositoryImpl(
    this.todosRemoteDatasource,
  );

  @override
  Future<Either<Failure, List<Todos>>> getTodos() async {
    try {
      final data = await todosRemoteDatasource.getTodos();
      return Right(data);
    } on SocketException catch (_) {
    
      return const Right([]);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message.toString()));
    }
  }

  @override
  Future<Either<Failure, List<User>>> getUsers() async {
    try {
      final data = await todosRemoteDatasource.getUsers();
      return Right(data);
    } on SocketException catch (_) {
      return const Right([]);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message.toString()));
    }
  }
}
