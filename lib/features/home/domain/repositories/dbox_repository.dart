import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/images_from_link.dart';

abstract class DboxRepository {
  Future<Either<Failure, ImagesFromLink>> getImagesFromLink(String link);
  Future<Either<Failure, List<ImagesFromLink>>> getRecents(String recents);
}
