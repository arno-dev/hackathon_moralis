import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/constants/data_status.dart';
import '../../../../../core/constants/push_notification_path.dart';
import '../../../domain/usecases/initialize_firebase_messaging.dart';

part 'push_notification_state.dart';
part 'push_notification_cubit.freezed.dart';

@injectable
class PushNotificationCubit extends Cubit<PushNotificationState> {
  final InitializeFirebaseMessagingUsecase initializeFirebaseMessagingUsecase;
  PushNotificationCubit(this.initializeFirebaseMessagingUsecase)
      : super(const PushNotificationState());

  Future<void> initializeFirebaseMessaging() async {
    final initialize = await initializeFirebaseMessagingUsecase(
        InitializeFirebaseMessagingParams(
      onMessageOpenedApp: (message) {
        print(message.toMap());
      },
      onSelectNotification: (payload) {
        print(payload);
      },
    ));
    initialize.fold(
      (errorMessage) {
        emit(state.copyWith(
            dataStatus: DataStatus.error, error: errorMessage.message));
      },
      (success) => emit(
        state.copyWith(dataStatus: DataStatus.loaded, error: null),
      ),
    );
  }
}
