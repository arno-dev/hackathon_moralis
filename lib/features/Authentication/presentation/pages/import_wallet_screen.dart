import 'package:d_box/core/config/themes/app_text_theme.dart';
import 'package:d_box/core/constants/colors.dart';
import 'package:d_box/core/widgets/base_button.dart';
import 'package:d_box/core/widgets/d_appbar.dart';
import 'package:d_box/core/widgets/d_box_alert_dialog.dart';
import 'package:d_box/core/widgets/d_box_check_box.dart';
import 'package:d_box/core/widgets/d_box_textfield.dart';
import 'package:d_box/core/widgets/d_box_un_ordered_list.dart';
import 'package:d_box/generated/assets.gen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../cubit/authentication_cubit_cubit.dart';

class ImportWalletPage extends StatelessWidget {
  const ImportWalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationCubit, AuthenticationState>(
      builder: (context, state) {
        return Scaffold(
          appBar: DAppBar(
            title: tr('importWallet'),
            titleStyle: Theme.of(context).textTheme.caption2,
            centerTitle: false,
          ),
          body: SafeArea(
              child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(left: 5.w, right: 5.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 10.w),
                  Center(child: Assets.images.importwallet.image()),
                  SizedBox(height: 15.w),
                  Text(tr('importYourWalletWithSecret'),
                      style: Theme.of(context).textTheme.subtitle3),
                  Text(tr('recoveryPhrase'),
                      style: Theme.of(context).textTheme.subtitle3),
                  SizedBox(height: 5.w),
                  DboxTextField(
                      isPassword: true,
                      height: 60,
                      hintText: tr('enterYourSecretRecoveryPhraseHere'),
                      controller:
                          context.read<AuthenticationCubit>().secretController),
                  SizedBox(height: 3.w),
                  DboxCheckBox(
                    title: tr('rememberMe'),
                    onTab: (value) {},
                  ),
                  SizedBox(height: 10.w),
                  BaseButton(
                    onTap: () => _dialogBuilder(context),
                    text: tr('import'),
                    buttonWidth: 100.w,
                    buttonHeight: 13.w,
                    backgroundColor: AppColors.primaryPurpleColor,
                    textColor: Colors.white,
                    isDisabled: !state.isInputValidated,
                  ),
                ],
              ),
            ),
          )),
        );
      },
    );
  }
}

Future<void> _dialogBuilder(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (_) {
      return BlocProvider.value(
        value: context.read<AuthenticationCubit>(),
        child: DboxAlertDialog(
            title: 'Secure your wallet',
            titleColor: Colors.red,
            content: [
              Assets.images.security.image(),
              SizedBox(height: 5.w),
              DboxUnorderedList(
                [
                  tr('secureYourWalletListText1'),
                  tr('secureYourWalletListText2')
                ],
                fontSize: 14,
              ),
              DboxCheckBox(
                title: tr('iGotIt'),
                onTab: (value) {
                  context.read<AuthenticationCubit>().changeCheckValue(value);
                },
              ),
              SizedBox(height: 3.w),
              BlocSelector<AuthenticationCubit, AuthenticationState, bool>(
                selector: (state) {
                  return state.isChecked;
                },
                builder: (context, isChecked) {
                  return BaseButton(
                      isDisabled: !isChecked,
                      text: tr('start'),
                      buttonWidth: 100.w,
                      backgroundColor: AppColors.primaryPurpleColor,
                      textColor: Colors.white,
                      buttonHeight: 13.w);
                },
              ),
              SizedBox(height: 3.w),
            ]),
      );
    },
  ).then((_) => context.read<AuthenticationCubit>().changeCheckValue(false));
}
