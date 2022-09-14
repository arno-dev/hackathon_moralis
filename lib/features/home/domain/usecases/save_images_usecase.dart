import 'package:d_box/features/home/data/models/params/upload_image_param/upload_image_param.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pinenacl/x25519.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/models/save_images_model.dart';
import '../repositories/dbox_repository.dart';

@lazySingleton
class SaveImagesUsecase implements UseCase<SaveImagesModel, SaveImagesParams> {
  final DboxRepository dboxRepository;
  SaveImagesUsecase(this.dboxRepository);

  @override
  Future<Either<Failure, SaveImagesModel>> call(
      SaveImagesParams saveImagesParams) async {
    return await dboxRepository.postSaveImages(
      saveImagesParams.uploadImageParam,
      saveImagesParams.destinationPublic,
    );
  }
}

class SaveImagesParams {
  final UploadImageParam uploadImageParam;
  final AsymmetricPublicKey destinationPublic;
  SaveImagesParams(this.uploadImageParam, this.destinationPublic);
}
