import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/images_from_link.dart';
import '../repositories/dbox_repository.dart';

@lazySingleton
class GetRecentsUsecase implements UseCase<List<ImagesFromLink>, NoParams> {
  final DboxRepository dboxRepository;
  GetRecentsUsecase(this.dboxRepository);

  @override
  Future<Either<Failure, List<ImagesFromLink>>> call(NoParams noParams) async {
    return await dboxRepository.getRecents();
  }
}
