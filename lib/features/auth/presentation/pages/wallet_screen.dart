import 'package:d_box/core/config/themes/app_text_theme.dart';
import 'package:d_box/core/constants/colors.dart';
import 'package:d_box/core/util/navigation.dart';
import 'package:d_box/core/widgets/base_button.dart';
import 'package:d_box/core/widgets/d_appbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:no_context_navigation/no_context_navigation.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/config/routes/router.dart';
import '../../../../core/widgets/d_box_alert_dialog.dart';
import '../../../../core/widgets/d_box_check_box.dart';
import '../../../../core/widgets/d_box_un_ordered_list.dart';
import '../../../../generated/assets.gen.dart';
import '../../../../generated/locale_keys.g.dart';
import '../cubit/authentication_cubit_cubit.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DAppBar(
        title: LocaleKeys.titleCloudmet.tr(),
        titleStyle: Theme.of(context).textTheme.caption2,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 5.w, right: 5.w),
          child: Column(
            children: [
              Image.asset(Assets.gifs.addfiles.path,
                  gaplessPlayback: true, fit: BoxFit.fill),
              Text(LocaleKeys.welcomeToCloudmet.tr(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.title2),
              SizedBox(height: 5.w),
              Text(LocaleKeys.welcomeContent.tr(), textAlign: TextAlign.center),
              SizedBox(height: 5.w),
              BaseButton(
                  onTap: () {
                    navService.pushNamed(AppRoute.importWalletRoute);
                  },
                  text: LocaleKeys.importWallet.tr(),
                  buttonWidth: 100.w,
                  backgroundColor: AppColors.primaryPurpleColor,
                  textColor: Colors.white,
                  buttonHeight: 13.w),
              SizedBox(height: 3.w),
              BaseButton(
                onTap: () {
                  Navigation.dBoxShowDialog(
                          context,
                          BlocProvider.value(
                            value: context.read<AuthenticationCubit>(),
                            child: DboxAlertDialog(
                                title: 'Secure your wallet',
                                titleColor: Colors.red,
                                content: [
                                  Assets.images.security.image(),
                                  SizedBox(height: 5.w),
                                  DboxUnorderedList(
                                    [
                                      LocaleKeys.secureYourWalletListText1.tr(),
                                      LocaleKeys.secureYourWalletListText2.tr()
                                    ],
                                    fontSize: 14,
                                  ),
                                  DboxCheckBox(
                                    title: LocaleKeys.iGotIt.tr(),
                                    onTab: (value) {
                                      context
                                          .read<AuthenticationCubit>()
                                          .changeCheckValue(value);
                                    },
                                  ),
                                  SizedBox(height: 3.w),
                                  BlocSelector<AuthenticationCubit,
                                      AuthenticationState, bool>(
                                    selector: (state) {
                                      return state.isChecked;
                                    },
                                    builder: (context, isChecked) {
                                      return BaseButton(
                                          onTap: () async {
                                            navService.goBack();
                                            await navService.pushNamed(
                                                AppRoute.createWalletRoute);
                                          },
                                          isDisabled: !isChecked,
                                          text: LocaleKeys.start.tr(),
                                          buttonWidth: 100.w,
                                          backgroundColor:
                                              AppColors.primaryPurpleColor,
                                          textColor: Colors.white,
                                          buttonHeight: 13.w);
                                    },
                                  ),
                                  SizedBox(height: 3.w),
                                ]),
                          ))
                      .then((_) => context
                          .read<AuthenticationCubit>()
                          .changeCheckValue(false));
                },
                text: LocaleKeys.createYourWallet.tr(),
                buttonWidth: 100.w,
                buttonHeight: 13.w,
                borderColor: AppColors.primaryPurpleColor,
                textColor: AppColors.primaryPurpleColor,
              ),
              SizedBox(height: 5.h),
            ],
          ),
        ),
      ),
    );
  }
}
