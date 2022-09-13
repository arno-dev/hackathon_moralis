import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/images_from_link.dart';
import '../repositories/dbox_repository.dart';

@lazySingleton
class GetImagesFromLinkUsecase
    implements UseCase<ImagesFromLink, GetImagesFromLinkParams> {
  final DboxRepository dboxRepository;
  GetImagesFromLinkUsecase(this.dboxRepository);

  @override
  Future<Either<Failure, ImagesFromLink>> call(
      GetImagesFromLinkParams params) async {
    return await dboxRepository.getImagesFromLink(params.link);
  }
}

class GetImagesFromLinkParams {
  final String link;
  GetImagesFromLinkParams(this.link);
}
