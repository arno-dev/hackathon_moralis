import 'package:d_box/core/config/routes/router.dart';
import 'package:d_box/core/config/themes/app_text_theme.dart';
import 'package:d_box/core/constants/colors.dart';
import 'package:d_box/core/constants/data_status.dart';
import 'package:d_box/core/widgets/base_button.dart';
import 'package:d_box/core/widgets/d_appbar.dart';
import 'package:d_box/core/widgets/d_box_check_box.dart';
import 'package:d_box/core/widgets/d_box_textfield.dart';
import 'package:d_box/generated/assets.gen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:no_context_navigation/no_context_navigation.dart';
import 'package:sizer/sizer.dart';

import '../../../../generated/locale_keys.g.dart';
import '../cubit/authentication_cubit_cubit.dart';

class ImportWalletPage extends StatelessWidget {
  const ImportWalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationCubit, AuthenticationState>(
      listener: (context, state) {
        if (state.dataStatus == DataStatus.isVerify) {
          navService.pushNamedAndRemoveUntil(AppRoute.homeRoute);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: DAppBar(
            onTap: () => navService.goBack(),
            title: LocaleKeys.importWallet.tr(),
            titleStyle: Theme.of(context).textTheme.caption2,
            centerTitle: false,
          ),
          body: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(left: 5.w, right: 5.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 10.w),
                  Center(child: Assets.images.importwallet.image()),
                  SizedBox(height: 15.w),
                  Text(LocaleKeys.importYourWalletWithSecret.tr(),
                      style: Theme.of(context).textTheme.subtitle3),
                  // Text(LocaleKeys.recoveryPhrase.tr(),
                  //     style: Theme.of(context).textTheme.subtitle3),
                  SizedBox(height: 5.w),
                  DboxTextField(
                      height: 6.5.h,
                      fontSize: 13.sp,
                      hintText: LocaleKeys.enterYourPriveteKeyHere.tr(),
                      errorText: state.error,
                      controller:
                          context.read<AuthenticationCubit>().secretController),
                  SizedBox(height: 3.w),
                  DboxCheckBox(
                    title: LocaleKeys.rememberMe.tr(),
                    onTab: (value) {},
                  ),
                  SizedBox(height: 10.w),
                  BaseButton(
                    onTap: () async => await context
                        .read<AuthenticationCubit>()
                        .saveCredentialFromPrivateKey(),
                    text: LocaleKeys.import.tr(),
                    buttonWidth: 100.w,
                    buttonHeight: 13.w,
                    backgroundColor: AppColors.primaryPurpleColor,
                    textColor: Colors.white,
                    isDisabled: !state.isInputValidated,
                  ),
                  SizedBox(height: 5.w),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
