import 'dart:io';

import 'package:d_box/core/config/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:no_context_navigation/no_context_navigation.dart';

import '../../../../core/widgets/d_box_button_bottom_sheet.dart';

class ShareBottomSheetWidget extends StatefulWidget {
  const ShareBottomSheetWidget({
    Key? key,
    required this.onUploadToCloud,
    required this.onAddAddress,
    required this.onScanQrCode,
  }) : super(key: key);
  final void Function() onUploadToCloud;
  final void Function() onAddAddress;
  final void Function(String) onScanQrCode;

  @override
  State<ShareBottomSheetWidget> createState() => _ShareBottomSheetWidgetState();
}

class _ShareBottomSheetWidgetState extends State<ShareBottomSheetWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DboxButtonBottomSheet(
          label: 'Upload to cloud',
          onTap: () async {
            navService.goBack();
            widget.onUploadToCloud();
          },
        ),
        DboxButtonBottomSheet(
          label: 'Add address',
          onTap: () {
            navService.goBack();
            widget.onAddAddress();
          },
        ),
        DboxButtonBottomSheet(
          label: 'Scan QR Code',
          onTap: () async {
            navService.goBack();
            navService.pushNamed(AppRoute.scanQrRoute).then((qrCode) {
              String? data = qrCode as String?;
              if (data != null) {
                widget.onScanQrCode(data);
              }
            });
          },
        ),
        Platform.isIOS ? const SizedBox(height: 20) : const SizedBox.shrink()
      ],
    );
  }
}


// Future<void> _dialogBuilder({
//   required BuildContext context,
//   bool isAddFolder = false,
// }) {
//   return showDialog<void>(
//     context: context,
//     builder: (_) {
//       return BlocProvider.value(
//         value: context.read<HomeCubit>(),
//         child: DboxAlertDialog(
//           title: isAddFolder ? "Add to folder" : 'Send to your friend',
//           titleColor: Colors.black,
//           content: [
//             isAddFolder
//                 ? const SizedBox.shrink()
//                 : DboxTextFieldDialog(
//                     hintText: "Add people",
//                     icons: Assets.icons.userplusicon.svg(
//                       width: 8.w,
//                       height: 8.w,
//                     ),
//                     onChange: (String text) {
//                       context.read<HomeCubit>().onAddPeopleChange(text);
//                     },
//                   ),
//             DboxTextFieldDialog(
//               hintText: "Add folder",
//               icons: Assets.icons.foldericon.svg(
//                 width: 8.w,
//                 height: 8.w,
//               ),
//               onChange: (String text) {
//                 context.read<HomeCubit>().onAddFolderChange(text);
//               },
//             ),
//             SizedBox(height: 1.w),
//             Padding(
//               padding: EdgeInsets.only(left: 6.w),
//               child: Text(
//                 "*Optional",
//                 style: TextStyle(
//                   color: AppColors.lighterGrey,
//                   fontSize: 12.0.sp,
//                 ),
//               ),
//             ),
//             SizedBox(height: 15.w),
//             BlocSelector<HomeCubit, HomeState, String?>(
//               selector: (state) {
//                 return state.addPeople;
//               },
//               builder: (context, addPeople) {
//                 return BaseButton(
//                   text: tr('send'),
//                   buttonWidth: 100.w,
//                   backgroundColor: AppColors.primaryPurpleColor,
//                   isDisabled: !isAddFolder,
//                   textColor: Colors.white,
//                   buttonHeight: 6.h,
//                   onTap: () async {
//                     navService.goBack();
//                     await context.read<HomeCubit>().onSaveImage();
//                   },
//                 );
//               },
//             ),
//             SizedBox(height: 3.w),
//             BaseButton(
//               text: isAddFolder ? "Not now" : tr('cancel'),
//               onTap: () {
//                 context.read<HomeCubit>().onCancelDialog();
//                 navService.goBack();
//               },
//               buttonWidth: 100.w,
//               backgroundColor: Colors.white,
//               textColor: isAddFolder ? Colors.red : Colors.black,
//               buttonHeight: 6.h,
//             ),
//           ],
//         ),
//       );
//     },
//   ).then((value) {
//     context.read<HomeCubit>().onCancelDialog();
//   });
// }
