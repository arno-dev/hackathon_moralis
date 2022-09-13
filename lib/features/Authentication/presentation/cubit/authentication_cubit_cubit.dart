import 'package:bloc/bloc.dart';
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

  AuthenticationCubit(this.getMnemonicUseCase) : super(const AuthenticationState(dataStatus: DataStatus.initial));

  Future<void> getMnemonicData() async{
    emit(state.copyWith(dataStatus: DataStatus.loading));
    final res = await getMnemonicUseCase(NoParams());
    res.fold((failure) => emit(state.copyWith(dataStatus: DataStatus.error,error: failure.message),), (r) {
      emit(state.copyWith(dataStatus: DataStatus.loaded, mnemonic: r));
    });

  }

  Future<void> nextStep() async {
    emit(state.copyWith(firstStep: false));
  }
  
}
