import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/dbox_repository.dart';

@lazySingleton
class PreviewImageUsecase implements UseCase<bool, PreviewImageParam> {
  final DboxRepository dboxRepository;
  PreviewImageUsecase(this.dboxRepository);

  @override
  Future<Either<Failure, bool>> call(
      PreviewImageParam previewImageParam) async {
    return await dboxRepository.previewFile(
      previewImageParam.url,
      previewImageParam.destinationPublic,
    );
  }
}

class PreviewImageParam {
  final String url;
  final String destinationPublic;

  PreviewImageParam(this.url, this.destinationPublic);
}
