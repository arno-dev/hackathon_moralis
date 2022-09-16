import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/dbox_repository.dart';

@lazySingleton
class GetMyQRCodeUseCase
    implements UseCase<String, NoParams> {
  final DboxRepository dboxRepository;
  GetMyQRCodeUseCase(this.dboxRepository);

  @override
  Future<Either<Failure, String>> call(NoParams noParams) async{
    return await dboxRepository.getMyQrCode();
  }
}

