import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/images_from_link.dart';
import '../../domain/repositories/dbox_repository.dart';
import '../datasources/dbox_remote_datasource.dart';

@LazySingleton(as: DboxRepository)
class DboxRepositoryImpl implements DboxRepository {
  final DboxRemoteDataSource dboxRemoteDataSource;

  DboxRepositoryImpl(this.dboxRemoteDataSource);
  @override
  Future<Either<Failure, ImagesFromLink>> getImagesFromLink(String link) async {
    try {
      final data = await dboxRemoteDataSource.getImageFromLink(link);
      return Right(data);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ImagesFromLink>>> getRecents(
      String recents) async {
    try {
      final data = await dboxRemoteDataSource.getRecents(recents);
      return Right(data);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message.toString()));
    }
  }
}
