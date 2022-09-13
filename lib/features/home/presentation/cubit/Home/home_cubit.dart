import 'package:d_box/features/home/domain/usecases/recenst_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/constants/data_status.dart';
import '../../../domain/entities/images.dart';
import '../../../domain/entities/images_from_link.dart';
import '../../../../home/domain/usecases/image_from_link_usecase.dart';

part 'home_state.dart';
part 'home_cubit.freezed.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  final GetImagesFromLinkUsecase getImagesFromLinkUsecase;
  final GetRecentsUsecase getRecentsUsecase;
  HomeCubit(this.getImagesFromLinkUsecase, this.getRecentsUsecase)
      : super(const HomeState());

  TextEditingController searchController = TextEditingController();

  Future<void> getUserFromLink(String link) async {
    emit(state.copyWith(dataStatus: DataStatus.loading));
    final request =
        await getImagesFromLinkUsecase(GetImagesFromLinkParams(link));
    request.fold(
      (error) => emit(state.copyWith(dataStatus: DataStatus.error)),
      (imagesFromLink) {
        emit(state.copyWith(
          dataStatus: DataStatus.loaded,
          imagesFromLink: imagesFromLink,
          currentFolder: imagesFromLink.filetreeEntity?.childrenEntity,
        ));
      },
    );
  }

  Future<void> getRecents(String recents) async {
    emit(state.copyWith(dataStatus: DataStatus.loading));
    final request = await getRecentsUsecase(GetRecentsParams(recents));
    request.fold(
      (error) => emit(state.copyWith(dataStatus: DataStatus.error)),
      (data) {
        emit(state.copyWith(
          dataStatus: DataStatus.loaded,
          recents: data,
        ));
      },
    );
  }

  // Future<void> onOpenFolder(Images images) async {
  //   emit(const HomeState.loaded());
  //   emit()
  // }
}
