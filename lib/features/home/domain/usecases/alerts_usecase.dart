import 'package:d_box/features/home/domain/entities/alerts.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/dbox_repository.dart';

@lazySingleton
class GetAlertsUseCase
    implements UseCase<List<Alerts>, GetAlertsParams> {
  final DboxRepository dboxRepository;
  GetAlertsUseCase(this.dboxRepository);

  @override
  Future<Either<Failure, List<Alerts>>> call(
      GetAlertsParams params) async {
    return await dboxRepository.getAlerts(params.address);
  }
}

class GetAlertsParams {
  final String address;
  GetAlertsParams(this.address);
}
