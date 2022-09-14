import 'package:d_box/core/config/themes/app_text_theme.dart';
import 'package:d_box/core/constants/colors.dart';
import 'package:d_box/core/widgets/base_button.dart';
import 'package:d_box/core/widgets/d_appbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DAppBar(
          title: tr('titleCloudmet'),
          titleStyle: Theme.of(context).textTheme.caption2,
          leading: false),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(left: 5.w, right: 5.w),
            child: Column(
              children: [
                Image.asset('assets/gifs/addfiles.gif',
                    gaplessPlayback: true, fit: BoxFit.fill),
                Column(
                  children: [
                    Text(tr('welcomeToCloudmet'),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.title2),
                    SizedBox(height: 5.w),
                    Text(tr('welcomeContent'), textAlign: TextAlign.center)
                  ],
                ),
                SizedBox(height: 5.w),
                Column(
                  children: [
                    BaseButton(
                        text: tr('importWallet'),
                        buttonWidth: 100.w,
                        backgroundColor: AppColors.primaryPurpleColor,
                        textColor: Colors.white,
                        buttonHeight: 13.w),
                    SizedBox(height: 3.w),
                    BaseButton(
                      text: tr('createYourWallet'),
                      buttonWidth: 100.w,
                      buttonHeight: 13.w,
                      borderColor: AppColors.primaryPurpleColor,
                      textColor: AppColors.primaryPurpleColor,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
