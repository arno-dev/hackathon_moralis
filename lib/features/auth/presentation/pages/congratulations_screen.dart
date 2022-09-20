import 'package:d_box/core/config/routes/router.dart';
import 'package:d_box/core/config/themes/app_text_theme.dart';
import 'package:d_box/core/constants/colors.dart';
import 'package:d_box/core/widgets/base_button.dart';
import 'package:d_box/core/widgets/d_appbar.dart';
import 'package:d_box/generated/assets.gen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:no_context_navigation/no_context_navigation.dart';
import 'package:sizer/sizer.dart';

import '../../../../generated/locale_keys.g.dart';

class CongratulationsPage extends StatelessWidget {
  const CongratulationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DAppBar(
        title: LocaleKeys.congretulations.tr(),
        titleStyle: Theme.of(context).textTheme.caption1,
      ),
      body: SingleChildScrollView(
        child: Container(
            margin: EdgeInsets.only(left: 5.w, right: 5.w),
            child: Column(
              children: [
                Image.asset(Assets.gifs.bingo.path,
                    gaplessPlayback: true, fit: BoxFit.fill),
                SizedBox(height: 5.w),
                Text(LocaleKeys.congretulationsContentText.tr(),
                    textAlign: TextAlign.center),
                SizedBox(height: 30.w),
                BaseButton(
                    onTap: () =>
                        navService.pushNamedAndRemoveUntil(AppRoute.homeRoute),
                    text: LocaleKeys.done.tr(),
                    buttonWidth: 100.w,
                    backgroundColor: AppColors.primaryPurpleColor,
                    textColor: Colors.white,
                    buttonHeight: 13.w),
              ],
            )),
      ),
    );
  }
}
