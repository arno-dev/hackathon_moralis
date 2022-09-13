import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/images_from_link.dart';
import '../repositories/dbox_repository.dart';

@lazySingleton
class GetImagesFromLinkUsecase
    implements UseCase<List<ImagesFromLink>, GetRecentsParams> {
  final DboxRepository dboxRepository;
  GetImagesFromLinkUsecase(this.dboxRepository);

  @override
  Future<Either<Failure, List<ImagesFromLink>>> call(
      GetRecentsParams params) async {
    return await dboxRepository.getRecents(params.recents);
  }
}

class GetRecentsParams {
  final String recents;
  GetRecentsParams(this.recents);
}
