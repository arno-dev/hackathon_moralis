import 'package:d_box/core/constants/url.dart';
import 'package:d_box/core/usecases/usecase.dart';
import 'package:d_box/features/home/data/models/params/upload_image_param/image_param.dart';
import 'package:d_box/features/home/data/models/params/upload_image_param/upload_image_param.dart';
import 'package:d_box/features/home/domain/usecases/pick_images_usecase.dart';
import 'package:d_box/features/home/domain/usecases/preview_image_usecase.dart';
import 'package:d_box/features/home/domain/usecases/recenst_usecase.dart';
import 'package:d_box/features/home/domain/usecases/save_images_usecase.dart';
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
  final PickImagesUsecase pickImagesUsecase;
  final SaveImagesUsecase saveImagesUsecase;
  final PreviewImageUsecase previewImageUsecase;
  HomeCubit(this.getImagesFromLinkUsecase, this.getRecentsUsecase,
      this.pickImagesUsecase, this.saveImagesUsecase, this.previewImageUsecase)
      : super(const HomeState());

  TextEditingController searchController = TextEditingController();
  TextEditingController addPeopleController = TextEditingController(text: "");
  TextEditingController addFolderController = TextEditingController(text: "");

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

  Future<void> getRecents() async {
    emit(state.copyWith(dataStatus: DataStatus.loading));
    final request = await getRecentsUsecase(NoParams());
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
      String name = state.recents?[rootIndex].filetreeEntity
              ?.childrenEntity?[childIndex].nameEntity ??
          "";
      List<String> nameStack = [name];
      print(nameStack);
      emit(
        state.copyWith(
          stack: newStack,
          dataStatus: DataStatus.loaded,
          currentFolder: current,
          nameStack: nameStack,
        ),
      );
    } else {
      List<int> newStack = [...state.stack, childIndex];
      List<Images>? current = state.currentFolder?[childIndex].childrenEntity;
      String name = state.currentFolder?[childIndex].nameEntity ?? "";
      List<String> nameStack = [...state.nameStack, name];
      print(nameStack);
      emit(
        state.copyWith(
          stack: newStack,
          dataStatus: DataStatus.loaded,
          currentFolder: current,
          nameStack: nameStack,
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
        nameStack: [],
      ));
    }
    List<int> newStack = [...state.stack];
    List<String> newNameStack = [...state.nameStack];
    newStack.removeAt(newStack.length - 1);
    newNameStack.removeAt(newStack.length - 1);
    List<Images>? current =
        state.recents?[newStack[0]].filetreeEntity?.childrenEntity;
    for (var element in newStack.asMap().entries) {
      if (element.key != 0) {
        current = current?[element.value].childrenEntity;
      }
    }
    print(newNameStack);
    emit(state.copyWith(
      dataStatus: DataStatus.loaded,
      stack: newStack,
      currentFolder: current,
      nameStack: newNameStack,
    ));
  }

  Future<void> onPreview(
      {required int rootIndex, required int childIndex}) async {
    String? newPath;
    newPath = AppUrl.urlMoralis;
    newPath = "$newPath${state.recents?[rootIndex].cidEntity}";
    if (state.stack.isEmpty) {
      String? nameFile = state.recents?[rootIndex].filetreeEntity
          ?.childrenEntity?[childIndex].nameEntity;
      newPath = "$newPath/$nameFile";
    } else {
      for (String folderName in state.nameStack) {
        newPath = "$newPath/$folderName";
      }
      String? fileName = state.currentFolder?[childIndex].nameEntity;
      newPath = "$newPath/$fileName";
    }
    String? destinationPublic = state.recents?[rootIndex].ipfsKeyEntity;
    print(newPath);
    if (destinationPublic != null) {
      await previewImageUsecase(PreviewImageParam(newPath, destinationPublic));
    } else {
      return emit(state.copyWith(dataStatus: DataStatus.error));
    }
  }

  Future<void> onPickImages() async {
    final request = await pickImagesUsecase(NoParams());
    request.fold((error) => emit(state.copyWith(dataStatus: DataStatus.error)),
        (data) async {
      emit(state.copyWith(listImages: data, isHasImage: data.isNotEmpty));
    });
  }

  Future<void> onSaveImage() async {
    final saveImageResponse = await saveImagesUsecase(SaveImagesParams(
      destinationPublic: state.addPeople,
      uploadImageParam: UploadImageParam(images: state.listImages),
      path: state.addFolder,
    ));
    saveImageResponse.fold(
      (errorMessage) => {emit(state.copyWith(dataStatus: DataStatus.error))},
      (response) async {
        emit(state.copyWith(
            addPeople: null, addFolder: "", listImages: [], isHasImage: false));
        await getRecents();
      },
    );
  }

  void onCancelDialog() {
    emit(state.copyWith(
      addFolder: "",
      addPeople: "",
      listImages: [],
      isHasImage: false,
    ));
  }

  void onAddPeopleChange(String text) {
    emit(state.copyWith(addPeople: text));
  }

  void onAddFolderChange(String text) {
    emit(state.copyWith(addFolder: text));
  }
}
