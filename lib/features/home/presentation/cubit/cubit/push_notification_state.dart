part of 'push_notification_cubit.dart';

@freezed
class PushNotificationState with _$PushNotificationState {
  const factory PushNotificationState({
    @Default(DataStatus.initial) DataStatus dataStatus,
    PushNotificationPath? pushNotificationPath,
    String? error,
  }) = _PushNotificationState;
}
