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

  Future<void> onOpenFolder(
      {required int rootIndex, required int childIndex}) async {
    emit(state.copyWith(dataStatus: DataStatus.loading));
    if (state.stack.isEmpty) {
      List<int> newStack = [rootIndex, childIndex];
      List<Images>? current = state.recents?[rootIndex].filetreeEntity
          ?.childrenEntity?[childIndex].childrenEntity;
      emit(
        state.copyWith(
          stack: newStack,
          dataStatus: DataStatus.loaded,
          currentFolder: current,
        ),
      );
    } else {
      List<int> newStack = [...state.stack, childIndex];
      List<Images>? current = state.currentFolder?[childIndex].childrenEntity;
      emit(
        state.copyWith(
          stack: newStack,
          dataStatus: DataStatus.loaded,
          currentFolder: current,
        ),
      );
    }
  }

  Future<void> onBackFolder() async {
    emit(state.copyWith(dataStatus: DataStatus.loading));
    if (state.stack.length <= 2) {
      return emit(state.copyWith(
        dataStatus: DataStatus.loaded,
        stack: [],
        currentFolder: null,
      ));
    }
    List<int> newStack = [...state.stack];
    newStack.removeAt(newStack.length - 1);
    List<Images>? current =
        state.recents?[newStack[0]].filetreeEntity?.childrenEntity;
    for (var element in newStack.asMap().entries) {
      if (element.key != 0) {
        current = current?[element.value].childrenEntity;
      }
    }
    emit(state.copyWith(
      dataStatus: DataStatus.loaded,
      stack: newStack,
      currentFolder: current,
    ));
  }
}
