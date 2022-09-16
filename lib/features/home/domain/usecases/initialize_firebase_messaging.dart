import 'package:dartz/dartz.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/notification_payload.dart';
import '../repositories/dbox_repository.dart';

@lazySingleton
class InitializeFirebaseMessagingUsecase
    implements UseCase<bool, InitializeFirebaseMessagingParams> {
  final DboxRepository dboxRepository;
  InitializeFirebaseMessagingUsecase(this.dboxRepository);

  @override
  Future<Either<Failure, bool>> call(
      InitializeFirebaseMessagingParams params) async {
    return await dboxRepository.initializeFirebaseMessaging(
      onMessageOpenedApp: params.onMessageOpenedApp,
      onSelectNotification: params.onSelectNotification,
    );
  }
}

class InitializeFirebaseMessagingParams {
  final void Function(RemoteMessage)? onMessageOpenedApp;
  final void Function(NotificationPayload?)? onSelectNotification;
  InitializeFirebaseMessagingParams({
    this.onMessageOpenedApp,
    this.onSelectNotification,
  });
}
