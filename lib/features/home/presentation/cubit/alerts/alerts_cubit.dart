import 'package:d_box/core/usecases/usecase.dart';
import 'package:d_box/features/home/domain/entities/alerts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/constants/data_status.dart';
import '../../../domain/usecases/alerts_usecase.dart';

part 'alerts_state.dart';
part 'alerts_cubit.freezed.dart';

@injectable
class AlertsCubit extends Cubit<AlertsState> {
  final GetAlertsUseCase getAlertsUseCase;
  AlertsCubit(this.getAlertsUseCase) : super(const AlertsState());

  Future<void> onDismissErorr() async {
    await Future<void>.delayed(const Duration(seconds: 5));
    emit(state.copyWith(errorMessage: null));
  }

  Future<void> getAlerts() async {
    emit(state.copyWith(dataStatus: DataStatus.loading));
    final request = await getAlertsUseCase(NoParams());
    request.fold(
      (error) {
        emit(state.copyWith(
            dataStatus: DataStatus.error, errorMessage: error.message));
      },
      (data) {
        emit(state.copyWith(
          dataStatus: DataStatus.loaded,
          alerts: data,
        ));
      },
    );
  }
}
