part of 'push_notification_cubit.dart';

@freezed
class PushNotificationState with _$PushNotificationState {
  const factory PushNotificationState({
    @Default(DataStatus.initial) DataStatus dataStatus,
    String? link,
    String? error,
  }) = _PushNotificationState;
}
