import 'package:d_box/features/home/data/models/params/upload_image_param/image_param.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/dbox_repository.dart';

@lazySingleton
class PickImagesUsecase implements UseCase<List<ImageParam>, NoParams> {
  final DboxRepository dboxRepository;
  PickImagesUsecase(this.dboxRepository);

  @override
  Future<Either<Failure, List<ImageParam>>> call(NoParams noParams) async {
    return await dboxRepository.pickImages();
  }
}
