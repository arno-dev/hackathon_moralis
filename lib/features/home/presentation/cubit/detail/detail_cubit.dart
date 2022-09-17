import 'package:d_box/core/constants/api_path.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/constants/data_status.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../domain/entities/images.dart';
import '../../../domain/entities/images_from_link.dart';
import '../../../domain/usecases/image_from_link_usecase.dart';
import '../../../domain/usecases/preview_image_usecase.dart';

part 'detail_state.dart';
part 'detail_cubit.freezed.dart';

@injectable
class DetailCubit extends Cubit<DetailState> {
  final GetImagesFromLinkUsecase getImagesFromLinkUsecase;
  final PreviewImageUsecase previewImageUsecase;

  DetailCubit(this.getImagesFromLinkUsecase, this.previewImageUsecase)
      : super(const DetailState());

  Future<void> onDismissErorr() async {
    await Future<void>.delayed(const Duration(seconds: 5));
    emit(state.copyWith(errorMessage: null));
  }

  Future<void> getUserFromLink(String link) async {
    emit(state.copyWith(dataStatus: DataStatus.loading));
    final request =
        await getImagesFromLinkUsecase(GetImagesFromLinkParams(link));
    request.fold(
      (error) => emit(state.copyWith(
          dataStatus: DataStatus.error, errorMessage: error.message)),
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
      String? stackName =
          state.currentFolder?[childIndex].nameEntity ?? LocaleKeys.noName.tr();
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
          stackName: []));
    }
    List<int> newStack = [...state.stack];
    List<String> newStackName = [...state.stackName];
    newStack.removeAt(newStack.length - 1);
    newStackName.removeAt(newStack.length - 1);
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
        stackName: newStackName));
  }

  Future<void> onPreview(
      {required int rootIndex, required int childIndex}) async {
    emit(state.copyWith(dataStatus: DataStatus.opening));
    String? newPath;
    newPath = ApiPath.urlMoralis;
    newPath = "$newPath${state.recents?[rootIndex].cidEntity}";
    if (state.stack.isEmpty) {
      String? nameFile = state.recents?[rootIndex].filetreeEntity
          ?.childrenEntity?[childIndex].nameEntity;
      newPath = "$newPath/$nameFile";
    } else {
      for (String folderName in state.stackName) {
        newPath = "$newPath/$folderName";
      }
      String? fileName = state.currentFolder?[childIndex].nameEntity;
      newPath = "$newPath/$fileName";
    }
    String? destinationPublic = state.recents?[rootIndex].ipfsKeyEntity;
    if (destinationPublic != null) {
      await previewImageUsecase(PreviewImageParam(newPath, destinationPublic));
      emit(state.copyWith(dataStatus: DataStatus.loaded));
    } else {
      return emit(state.copyWith(
          dataStatus: DataStatus.error,
          errorMessage: LocaleKeys.errorMessages_previewInvalid.tr()));
    }
  }

  @override
  Future<void> close() async {
    await onDismissErorr();
    return super.close();
  }
}
