import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/constants/data_status.dart';

part 'my_account_state.dart';
part 'my_account_cubit.freezed.dart';

@injectable
class MyAccountCubit extends Cubit<MyAccountState> {
  MyAccountCubit()
      : super(const MyAccountState(dataStatus: DataStatus.initial));

  void changeSwitchPushNotification(value) {
    emit(state.copyWith(isPushNotifacationChecked: value));
  }
}
