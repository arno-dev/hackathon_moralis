import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:no_context_navigation/no_context_navigation.dart';

import '../../../../core/constants/pick_file_type.dart';
import '../../../../core/widgets/d_box_button_bottom_sheet.dart';
import '../cubit/Home/home_cubit.dart';

class UploadBottomSheetWidget extends StatelessWidget {
  const UploadBottomSheetWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DboxButtonBottomSheet(
          label: 'Upload Photos',
          onTap: () async {
            await context.read<HomeCubit>().onPickImages(PickFileType.photos);
            navService.goBack();
          },
        ),
        DboxButtonBottomSheet(
          label: 'Take Photos',
          onTap: () async {
            // _dialogBuilder(context);
            await context
                .read<HomeCubit>()
                .onPickImages(PickFileType.takePhoto);
            navService.goBack();
          },
        ),
        DboxButtonBottomSheet(
          label: 'Upload files',
          onTap: () async {
            await context.read<HomeCubit>().onPickImages(PickFileType.files);
            navService.goBack();
          },
        ),
        Platform.isIOS ? const SizedBox(height: 20) : const SizedBox.shrink()
      ],
    );
  }
}
