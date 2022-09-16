import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/constants/data_status.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/authentication_usecase.dart';
import '../../domain/usecases/save_credential_from_private_usecase.dart';
import '../../domain/usecases/save_credential_usecase.dart';
part 'authentication_cubit_state.dart';
part 'authentication_cubit_cubit.freezed.dart';

@injectable
class AuthenticationCubit extends Cubit<AuthenticationState> {
  final GetMnemonicUseCase getMnemonicUseCase;
  final SaveCredentialUseCase saveCredentialUseCase;
  final SaveCredentialFromPrivateKeyUseCase saveCredentialFromPrivateKeyUseCase;

  List<String> randomData =[];
  late TextEditingController secretController;
  AuthenticationCubit(this.getMnemonicUseCase, this.saveCredentialUseCase, this.saveCredentialFromPrivateKeyUseCase,)
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
    emit(state.copyWith(dataStatus: DataStatus.loaded, mnemonic: r,newMnemonic: List.generate(r.length, (index) => "").toList()));
    randomData = [...?state.mnemonic];
    randomData.shuffle();
      
    });
  }

  Future<void> firstStep(bool isNext) async {
    emit(state.copyWith(firstStep: isNext));
  }

  void updateNewMnemonic(int index, {bool isAdding = false}) {
    List<String> store = [...?state.newMnemonic];
    if (isAdding) {
      int? currentIndex =
          state.newMnemonic?.where((value) => value != '').toList().length;

      if (currentIndex == null) {
        return;
      }

      if (currentIndex < state.newMnemonic!.length) {
        store[currentIndex] = randomData[index];
      }
    } else {
      store.removeAt(index);
      store.add('');
    }
    emit(state.copyWith(newMnemonic: store));
  }
  
  Future<void> saveCredential() async {
    emit(state.copyWith(dataStatus: DataStatus.loading));
    if (state.mnemonic.toString() == state.newMnemonic.toString()) {
      final saveCredential = await saveCredentialUseCase(state.mnemonic!);
      saveCredential.fold(
        (error) => emit(
            state.copyWith(dataStatus: DataStatus.error, error: error.message)),
        (data) {
          emit(state.copyWith(
            dataStatus: DataStatus.isVerify,
          ));
        },
      );
    }else{
      emit(state.copyWith(dataStatus: DataStatus.error));
    }
  }

  void changeCheckValue(value) {
    emit(state.copyWith(isChecked: value));
  }
  
  @override
  Future<void> close() {
    secretController.dispose();
    return super.close();
  }

   Future<void> saveCredentialFromPrivateKey() async {
    emit(state.copyWith(dataStatus: DataStatus.loading));

      final saveCredential = await saveCredentialFromPrivateKeyUseCase(secretController.text);
      // final saveCredential = await saveCredentialFromPrivateKeyUseCase("0x71C7656EC7ab88b098defB751B7401B5f6d8976F"); // TODO:hard code private key
      saveCredential.fold(
        (error) => emit(
            state.copyWith(dataStatus: DataStatus.error, error: error.message)),
        (data) {
          emit(state.copyWith(
            dataStatus: DataStatus.isVerify,
          ));
        },
      );
  
  }

   
}
