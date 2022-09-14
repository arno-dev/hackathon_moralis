import 'package:d_box/features/home/data/models/params/upload_image_param/upload_image_param.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/models/save_images_model.dart';
import '../repositories/dbox_repository.dart';

@lazySingleton
class SaveImagesUsecase implements UseCase<SaveImagesModel, UploadImageParam> {
  final DboxRepository dboxRepository;
  SaveImagesUsecase(this.dboxRepository);

  @override
  Future<Either<Failure, SaveImagesModel>> call(
      UploadImageParam uploadImageParam) async {
    return await dboxRepository.postSaveImages(uploadImageParam);
  }
}
