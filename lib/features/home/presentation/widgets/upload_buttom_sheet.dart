import 'dart:io';

import 'package:flutter/material.dart';
import 'package:no_context_navigation/no_context_navigation.dart';

import '../../../../core/widgets/d_box_button_bottom_sheet.dart';

class UploadBottomSheetWidget extends StatelessWidget {
  const UploadBottomSheetWidget({
    Key? key,
    required this.onUploadPhotos,
    required this.onTakePhoto,
    required this.onUploadFiles,
  }) : super(key: key);
  final void Function() onUploadPhotos;
  final void Function() onTakePhoto;
  final void Function() onUploadFiles;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DboxButtonBottomSheet(
          label: 'Upload Photos',
          onTap: () async {
            navService.goBack();
            onUploadPhotos();
          },
        ),
        DboxButtonBottomSheet(
          label: 'Take Photos',
          onTap: () async {
            // _dialogBuilder(context);
            navService.goBack();
            onTakePhoto();
            // await context
            //     .read<HomeCubit>()
            //     .onPickImages(PickFileType.takePhoto);
          },
        ),
        DboxButtonBottomSheet(
          label: 'Upload files',
          onTap: () async {
            navService.goBack();
            onUploadFiles();
            // await context.read<HomeCubit>().onPickImages(PickFileType.files);
          },
        ),
        Platform.isIOS ? const SizedBox(height: 20) : const SizedBox.shrink()
      ],
    );
  }
}
