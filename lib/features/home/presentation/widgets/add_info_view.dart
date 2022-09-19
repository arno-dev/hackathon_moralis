import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:no_context_navigation/no_context_navigation.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/widgets/base_button.dart';
import '../../../../core/widgets/d_box_alert_dialog.dart';
import '../../../../core/widgets/d_box_textfield_dialog.dart';
import '../../../../generated/assets.gen.dart';

class AddInfo extends StatelessWidget {
  const AddInfo({
    Key? key,
    required this.isAddFolder,
    required this.isDisableSend,
    required this.onSaveImage,
    required this.addFolderController,
    required this.addPeopleController,
  }) : super(key: key);
  final bool isAddFolder;
  final bool isDisableSend;
  final void Function() onSaveImage;
  final TextEditingController addFolderController;
  final TextEditingController addPeopleController;

  @override
  Widget build(BuildContext context) {
    return DboxAlertDialog(
      title: isAddFolder ? "Add to folder" : 'Send to your friend',
      titleColor: Colors.black,
      content: [
        isAddFolder
            ? const SizedBox.shrink()
            : DboxTextFieldDialog(
                controller: addPeopleController,
                hintText: "Add people",
                icons: Assets.icons.userplusicon.svg(
                  width: 8.w,
                  height: 8.w,
                ),
              ),
        DboxTextFieldDialog(
          hintText: "Add folder",
          controller: addFolderController,
          icons: Assets.icons.foldericon.svg(
            width: 8.w,
            height: 8.w,
          ),
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
        BaseButton(
          text: tr('send'),
          buttonWidth: 100.w,
          backgroundColor: AppColors.primaryPurpleColor,
          isDisabled: false,
          textColor: Colors.white,
          buttonHeight: 6.h,
          onTap: () async {
            navService.goBack();
            onSaveImage();
          },
        ),
        SizedBox(height: 3.w),
        BaseButton(
          text: isAddFolder ? "Not now" : tr('cancel'),
          onTap: () {
            navService.goBack();
          },
          buttonWidth: 100.w,
          backgroundColor: Colors.white,
          textColor: isAddFolder ? Colors.red : Colors.black,
          buttonHeight: 6.h,
        ),
      ],
    );
  }
}
