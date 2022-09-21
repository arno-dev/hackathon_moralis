import 'package:d_box/core/constants/pick_file_type.dart';
import 'package:d_box/core/usecases/usecase.dart';
import 'package:d_box/features/home/data/models/params/upload_image_param/image_param.dart';
import 'package:d_box/features/home/data/models/params/upload_image_param/upload_image_param.dart';
import 'package:d_box/features/home/domain/usecases/pick_images_usecase.dart';
import 'package:d_box/features/home/domain/usecases/preview_image_usecase.dart';
import 'package:d_box/features/home/domain/usecases/recenst_usecase.dart';
import 'package:d_box/features/home/domain/usecases/save_images_usecase.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../../../../core/constants/api_path.dart';
import '../../../../../core/constants/data_status.dart';
import '../../../../../generated/locale_keys.g.dart';
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

  TextEditingController searchController = TextEditingController();
  TextEditingController addPeopleController = TextEditingController();
  TextEditingController addFolderController = TextEditingController(text: "");
  HomeCubit(this.getImagesFromLinkUsecase, this.getRecentsUsecase,
      this.pickImagesUsecase, this.saveImagesUsecase, this.previewImageUsecase)
      : super(const HomeState()) {
    addPeopleController.addListener(() {
      if (addPeopleController.text.isEmpty && state.isDisableUpload) {
        emit(state.copyWith(isDisableUpload: false));
      }
    });
  }

  QRViewController? qrController;

  Future<void> onDismissErorr() async {
    await Future<void>.delayed(const Duration(seconds: 5));
    emit(state.copyWith(errorMessage: null));
  }

  Future<void> getRecents() async {
    emit(state.copyWith(dataStatus: DataStatus.loading));
    final request = await getRecentsUsecase(NoParams());
    request.fold(
      (error) {
        emit(state.copyWith(
            dataStatus: DataStatus.error, errorMessage: error.message));
      },
      (data) {
        emit(state.copyWith(
          dataStatus: DataStatus.loaded,
          recents: data,
        ));
      },
    );
  }

  void onOpenFolder({required int rootIndex, required int childIndex}) {
    emit(state.copyWith(dataStatus: DataStatus.loading));
    if (state.stack.isEmpty) {
      List<int> newStack = [rootIndex, childIndex];
      List<Images>? current = state.recents?[rootIndex].filetreeEntity
          ?.childrenEntity?[childIndex].childrenEntity;
      String name = state.recents?[rootIndex].filetreeEntity
              ?.childrenEntity?[childIndex].nameEntity ??
          "";
      List<String> nameStack = [name];
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

  void onBackFolder() {
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
    emit(state.copyWith(
      dataStatus: DataStatus.loaded,
      stack: newStack,
      currentFolder: current,
      nameStack: newNameStack,
    ));
  }

  Future<void> onPreview(
      {required int rootIndex, required int childIndex}) async {
    emit(state.copyWith(dataStatus: DataStatus.loading));

    String? newPath;
    newPath = ApiPath.urlMoralis;
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
    if (destinationPublic != null) {
      final previewImage = await previewImageUsecase(
          PreviewImageParam(newPath, destinationPublic));
      previewImage.fold(
        (error) {
          return emit(state.copyWith(
              dataStatus: DataStatus.error, errorMessage: error.message));
        },
        (response) {
          return emit(state.copyWith(dataStatus: DataStatus.loaded));
        },
      );
    } else {
      return emit(state.copyWith(
          dataStatus: DataStatus.error,
          errorMessage: LocaleKeys.errorMessages_previewInvalid.tr()));
    }
  }

  Future<void> onPickImages(PickFileType pickFileType) async {
    emit(state.copyWith(isHasImage: false));
    final request = await pickImagesUsecase(pickFileType);
    request.fold((error) {
      emit(state.copyWith(
          dataStatus: DataStatus.error, errorMessage: error.message));
    }, (data) async {
      emit(state.copyWith(listImages: data, isHasImage: data.isNotEmpty));
    });
  }

  Future<void> onSaveImage() async {
    emit(state.copyWith(dataStatus: DataStatus.loading));
    final saveImageResponse = await saveImagesUsecase(SaveImagesParams(
      destinationPublic:
          addPeopleController.text.isEmpty ? null : addPeopleController.text,
      uploadImageParam: UploadImageParam(images: state.listImages),
      path: addFolderController.text,
    ));
    saveImageResponse.fold(
      (error) {
        onCancelDialog();
        emit(state.copyWith(
            dataStatus: DataStatus.error, errorMessage: error.message));
      },
      (response) async {
        onCancelDialog();
        emit(state.copyWith(
          dataStatus: DataStatus.loaded,
        ));
        await getRecents();
      },
    );
  }

  void onCancelDialog() {
    addPeopleController.clear();
    addFolderController.clear();
    emit(state.copyWith(
      listImages: [],
      isHasImage: false,
      isHasQrAddress: false,
      isDisableUpload: true,
    ));
  }

  void onQrCode(String text) {
    addPeopleController.text = text;
    emit(state.copyWith(
      isHasQrAddress: true,
      isHasImage: false,
    ));
  }

  @override
  Future<void> close() {
    searchController.dispose();
    addPeopleController.dispose();
    addFolderController.dispose();
    return super.close();
  }
}
