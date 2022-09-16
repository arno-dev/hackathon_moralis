import 'dart:io';

import 'package:d_box/features/home/presentation/widgets/qr_code_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:no_context_navigation/no_context_navigation.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/widgets/base_button.dart';
import '../../../../core/widgets/d_box_alert_dialog.dart';
import '../../../../core/widgets/d_box_button_bottom_sheet.dart';
import '../../../../core/widgets/d_box_textfield_dialog.dart';
import '../../../../generated/assets.gen.dart';
import '../cubit/Home/home_cubit.dart';

class ShareBottomSheetWidget extends StatefulWidget {
  const ShareBottomSheetWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<ShareBottomSheetWidget> createState() => _ShareBottomSheetWidgetState();
}

class _ShareBottomSheetWidgetState extends State<ShareBottomSheetWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state.isHasQrAddress) {
          _dialogBuilder(context: context, isAddFolder: true);
        }
      },
      listenWhen: ((previous, current) =>
          previous.isHasQrAddress != current.isHasQrAddress),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DboxButtonBottomSheet(
            label: 'Upload to cloud',
            onTap: () async {
              navService.goBack();
              await context.read<HomeCubit>().onSaveImage();
              
            },
          ),
          DboxButtonBottomSheet(
            label: 'Add address',
            onTap: () {
              _dialogBuilder(context: context);
              // navService.goBack();
            },
          ),
          DboxButtonBottomSheet(
            label: 'Scan QR Code',
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => BlocProvider<HomeCubit>.value(
                  value: context.read<HomeCubit>(),
                  child: DboxQRView(),
                ),
              ));
            },
          ),
          Platform.isIOS ? const SizedBox(height: 20) : const SizedBox.shrink()
        ],
      ),
    );
  }
}

Future<void> _dialogBuilder({
  required BuildContext context,
  bool isAddFolder = false,
}) {
  return showDialog<void>(
    context: context,
    builder: (_) {
      return BlocProvider.value(
        value: context.read<HomeCubit>(),
        child: DboxAlertDialog(
          title: isAddFolder ? "Add to folder" : 'Send to your friend',
          titleColor: Colors.black,
          content: [
            isAddFolder
                ? const SizedBox.shrink()
                : DboxTextFieldDialog(
                    hintText: "Add people",
                    icons: Assets.icons.userplusicon.svg(
                      width: 8.w,
                      height: 8.w,
                    ),
                    onChange: (String text) {
                      context.read<HomeCubit>().onAddPeopleChange(text);
                    },
                  ),
            DboxTextFieldDialog(
              hintText: "Add folder",
              icons: Assets.icons.foldericon.svg(
                width: 8.w,
                height: 8.w,
              ),
              onChange: (String text) {
                context.read<HomeCubit>().onAddFolderChange(text);
              },
            ),
            SizedBox(height: 1.w),
            Padding(
              padding: EdgeInsets.only(left: 6.w),
              child: Text(
                "*Optional",
                style: TextStyle(
                  color: AppColors.lighterGrey,
                  fontSize: 12.0.sp,
                ),
              ),
            ),
            SizedBox(height: 15.w),
            BlocSelector<HomeCubit, HomeState, String?>(
              selector: (state) {
                return state.addPeople;
              },
              builder: (context, addPeople) {
                return BaseButton(
                  text: tr('send'),
                  buttonWidth: 100.w,
                  backgroundColor: AppColors.primaryPurpleColor,
                  isDisabled: !isAddFolder,
                  textColor: Colors.white,
                  buttonHeight: 6.h,
                  onTap: () async {
                    navService.goBack();
                    await context.read<HomeCubit>().onSaveImage();
                  },
                );
              },
            ),
            SizedBox(height: 3.w),
            BaseButton(
              text: isAddFolder ? "Not now" : tr('cancel'),
              onTap: () {
                context.read<HomeCubit>().onCancelDialog();
                navService.goBack();
              },
              buttonWidth: 100.w,
              backgroundColor: Colors.white,
              textColor: isAddFolder ? Colors.red : Colors.black,
              buttonHeight: 6.h,
            ),
          ],
        ),
      );
    },
  ).then((value) {
    context.read<HomeCubit>().onCancelDialog();
  });
}
