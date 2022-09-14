import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/constants/data_status.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/authentication_usecase.dart';
part 'authentication_cubit_state.dart';
part 'authentication_cubit_cubit.freezed.dart';

@injectable
class AuthenticationCubit extends Cubit<AuthenticationState> {
  final GetMnemonicUseCase getMnemonicUseCase;
  late TextEditingController secretController;
  AuthenticationCubit(this.getMnemonicUseCase)
      : super(const AuthenticationState(dataStatus: DataStatus.initial)) {
    secretController = TextEditingController();
    secretController.addListener(() {
      if (secretController.text.length > 3) {
        emit(state.copyWith(isInputValidated: true));
      } else {
        emit(state.copyWith(isInputValidated: false));
      }
    });
  }

  Future<void> getMnemonicData() async {
    emit(state.copyWith(dataStatus: DataStatus.loading));
    final res = await getMnemonicUseCase(NoParams());
    res.fold(
        (failure) => emit(
              state.copyWith(
                  dataStatus: DataStatus.error, error: failure.message),
            ), (r) {
      emit(state.copyWith(dataStatus: DataStatus.loaded, mnemonic: r));
    });
  }

  Future<void> nextStep() async {
    emit(state.copyWith(firstStep: false));
  }

  void changeCheckValue(value) {
    emit(state.copyWith(isChecked: value));
  }

  @override
  Future<void> close() {
    secretController.dispose();
    return super.close();
  }
}
