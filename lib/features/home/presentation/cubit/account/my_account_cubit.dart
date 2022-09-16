import 'package:d_box/core/error/failures.dart';
import 'package:d_box/core/usecases/usecase.dart';
import 'package:d_box/features/home/domain/usecases/my_qr_code_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/constants/data_status.dart';

part 'my_account_state.dart';
part 'my_account_cubit.freezed.dart';

@injectable
class MyAccountCubit extends Cubit<MyAccountState> {
  final GetMyQRCodeUseCase getMyQRCodeUseCase;
  MyAccountCubit(this.getMyQRCodeUseCase)
      : super(const MyAccountState(dataStatus: DataStatus.initial));
  void changeSwitchPushNotification(value) {
    emit(state.copyWith(isPushNotifacationChecked: value));
  }

  Future<void> getMyQrCode() async {
    final qrcode = await getMyQRCodeUseCase(NoParams());
    qrcode.fold(
      (error) => emit(state.copyWith(dataStatus: DataStatus.error)),
      (data) {
        emit(state.copyWith(
          dataStatus: DataStatus.loaded,
          qrCode: data,
        ));
      },
    );
  }
}
