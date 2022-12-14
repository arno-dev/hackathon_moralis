part of 'authentication_cubit_cubit.dart';

@freezed
class AuthenticationState with _$AuthenticationState {
  const factory AuthenticationState({
    @Default(DataStatus.initial) DataStatus dataStatus,
    @Default(true) bool isCreateWallPage,
    List<String>? mnemonic,
    List<String>? newMnemonic,
    String? error,
    @Default(false) bool isChecked,
    @Default(false) bool isInputValidated,
  }) = _Initial;
}
