part of 'authentication_cubit_cubit.dart';

@freezed
class AuthenticationState with _$AuthenticationState {
  const factory AuthenticationState({
     @Default(DataStatus.initial) DataStatus dataStatus,
     @Default(true) bool firstStep,
     List<String>? mnemonic,
     List<String>? newMnemonic,
       String? error,
  }) = _Initial;
}
