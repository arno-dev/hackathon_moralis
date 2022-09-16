import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/constants/data_status.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../home/data/models/params/upload_image_param/image_param.dart';
import '../../../home/domain/entities/images.dart';
import '../../../home/domain/entities/images_from_link.dart';
import '../../../home/domain/usecases/image_from_link_usecase.dart';

part 'detail_state.dart';
part 'detail_cubit.freezed.dart';

@injectable
class DetailCubit extends Cubit<DetailState> {
  final GetImagesFromLinkUsecase getImagesFromLinkUsecase;
  DetailCubit(this.getImagesFromLinkUsecase) : super(const DetailState());

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
          recents: [imagesFromLink],
          currentFolder: imagesFromLink.filetreeEntity?.childrenEntity,
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
      String? stackName = state.recents?[rootIndex].filetreeEntity
              ?.childrenEntity?[childIndex].nameEntity ??
            LocaleKeys.noName.tr();

      emit(
        state.copyWith(
          stack: newStack,
          stackName: [stackName],
          dataStatus: DataStatus.loaded,
          currentFolder: current,
        ),
      );
    } else {
      List<int> newStack = [...state.stack, childIndex];
      List<Images>? current = state.currentFolder?[childIndex].childrenEntity;
        String? stackName =  state.currentFolder?[childIndex].nameEntity ??
            LocaleKeys.noName.tr();
      List<String> newStackName = [...state.stackName, stackName];
      emit(
        state.copyWith(
          stack: newStack,
          stackName: newStackName,
          dataStatus: DataStatus.loaded,
          currentFolder: current,
        ),
      );
    }
  }

  Future<void> onBackFolder() async {
    emit(state.copyWith(dataStatus: DataStatus.loading));
    if (state.stack.length <= 1) {
      return emit(state.copyWith(
        dataStatus: DataStatus.loaded,
        stack: [],
        currentFolder: null,
        stackName: []
      ));
    }
    List<int> newStack = [...state.stack];
     List<String> newStackName = [...state.stackName];
    newStack.removeAt(newStack.length - 1);
     newStackName.removeAt(newStack.length -1);
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
      stackName: newStackName
    ));
  }
}
