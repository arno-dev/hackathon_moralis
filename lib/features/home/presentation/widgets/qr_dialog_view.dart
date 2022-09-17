import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/widgets/base_button.dart';
import '../../../../core/widgets/d_box_alert_dialog.dart';
import '../../../../generated/locale_keys.g.dart';

class QrDialogView extends StatelessWidget {
  const QrDialogView({
    Key? key,
    required this.screenshotController,
    required this.qrCode,
  }) : super(key: key);

  final ScreenshotController screenshotController;
  final String qrCode;

  @override
  Widget build(BuildContext context) {
    return DboxAlertDialog(
        title: LocaleKeys.showThisToYourFriends.tr(),
        contentPadding: 0,
        actionsPadding: 0,
        content: [
          SizedBox(height: 5.w),
          Center(
            child: Screenshot(
              controller: screenshotController,
              child: QrImage(
                data: qrCode,
                version: QrVersions.auto,
                size: 200.0,
              ),
            ),
          ),
          SizedBox(height: 5.w),
          Center(
            child: BaseButton(
                onTap: () {
                  screenshotController
                      .capture(delay: const Duration(milliseconds: 10))
                      .then((capturedImage) async {
                    await [Permission.storage].request();
                    var result = await ImageGallerySaver.saveImage(
                        capturedImage!,
                        name: LocaleKeys.screenshot.tr());
                    return result['filePath'];
                  });
                },
                text: LocaleKeys.save.tr(),
                buttonWidth: 50.w,
                backgroundColor: AppColors.primaryPurpleColor,
                textColor: Colors.white,
                buttonHeight: 13.w),
          ),
          SizedBox(height: 5.w)
        ]);
  }
}
