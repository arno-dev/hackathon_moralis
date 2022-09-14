import 'package:d_box/core/constants/colors.dart';
import 'package:d_box/core/widgets/base_button.dart';
import 'package:d_box/core/widgets/d_appbar.dart';
import 'package:d_box/core/widgets/d_box_check_box.dart';
import 'package:d_box/core/widgets/d_box_textfield.dart';
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
        return Sizer(
          builder: ((context, orientation, deviceType) {
            return Scaffold(
              appBar: DAppBar(title: tr('importWallet'),centerTitle: false,),
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
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(tr('recoveryPhrase'),
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 5.w),
                      DboxTextField(
                          isPassword: true,
                          height: 60,
                          hintText: tr('enterYourSecretRecoveryPhraseHere'),
                          controller: context
                              .read<AuthenticationCubit>()
                              .secretController),
                      SizedBox(height: 3.w),
                      DboxCheckBox(
                        title: tr('rememberMe'),
                        onTab: (value) {},
                      ),
                      SizedBox(height: 10.w),
                      BaseButton(
                        text: tr('import'),
                        buttonWidth: 100.w,
                        buttonHeight: 13.w,
                        backgroundColor: AppColors.primaryPurpleColor,
                        color: Colors.white,
                        isDisabled:!state.isInputValidated,
                      ),
                    ],
                  ),
                ),
              )),
            );
          }),
        );
      },
    );
  }
}
