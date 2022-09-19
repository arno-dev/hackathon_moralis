import 'dart:io';

import 'package:flutter/material.dart';
import 'package:no_context_navigation/no_context_navigation.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/widgets/base_button.dart';

class DboxQRView extends StatefulWidget {
  const DboxQRView({Key? key}) : super(key: key);

  @override
  State<DboxQRView> createState() => _DboxQRViewState();
}

class _DboxQRViewState extends State<DboxQRView> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: AppColors.primaryPurpleColor,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 60.w,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Column(children: [
                  SizedBox(
                    height: 1.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BaseButton(
                        text: "Pause Scan",
                        buttonWidth: 40.w,
                        backgroundColor: AppColors.primaryPurpleColor,
                        textColor: Colors.white,
                        buttonHeight: 6.h,
                        onTap: () async {
                          controller!.pauseCamera();
                        },
                      ),
                      BaseButton(
                        text: "Resume Scan",
                        buttonWidth: 40.w,
                        backgroundColor: AppColors.primaryPurpleColor,
                        textColor: Colors.white,
                        buttonHeight: 6.h,
                        onTap: () async {
                          controller!.resumeCamera();
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  BaseButton(
                    text: "Back",
                    buttonWidth: 100.w,
                    backgroundColor: AppColors.primaryPurpleColor,
                    textColor: Colors.white,
                    buttonHeight: 6.h,
                    onTap: () async {
                      navService.goBack();
                    },
                  )
                ]),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (scanData.code != null) {
        controller.pauseCamera();
        // context.read<HomeCubit>().onQrCode(scanData.code.toString());
        // widget.onQrCode(scanData.code);
        navService.goBack(result: scanData.code);
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
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
//               controller: context.read<HomeCubit>().addFolderController,
//               hintText: "Add folder",
//               icons: Assets.icons.foldericon.svg(
//                 width: 8.w,
//                 height: 8.w,
//               ),
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
//                   isDisabled: !isAddFolder && addPeople != null,
//                   textColor: Colors.white,
//                   buttonHeight: 6.h,
//                   onTap: () async {
//                     await context.read<HomeCubit>().onSaveImage();
//                     navService.goBack();
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
//     // context.read<HomeCubit>().onCancelDialog();
//   });
// }
