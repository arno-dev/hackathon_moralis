part of 'alerts_cubit.dart';

@freezed
class AlertsState with _$AlertsState {
  const factory AlertsState({
    @Default(DataStatus.initial) DataStatus dataStatus,
    List<Alerts>? alerts,
  }) = _Initial;
}
