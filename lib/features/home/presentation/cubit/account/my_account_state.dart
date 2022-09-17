part of 'my_account_cubit.dart';

@freezed
class MyAccountState with _$MyAccountState {
  const factory MyAccountState({
    @Default(DataStatus.initial) DataStatus dataStatus,
    @Default(false) bool isPushNotifacationChecked,
    @Default("") String qrCode,
    String? errorMessage
  }) = _Initial;
}
