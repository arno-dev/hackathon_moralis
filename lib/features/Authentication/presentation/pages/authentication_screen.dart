import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/widgets/base_button.dart';
import '../../../../core/widgets/d_appbar.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../core/config/themes/app_text_theme.dart';
import '../cubit/authentication_cubit_cubit.dart';
import '../widgets/authentication_grid.dart';
import '../widgets/d_stepper.dart';

class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationCubit, AuthenticationState>(
      builder: (context, state) {
        return Sizer(builder: ((context, orientation, deviceType) {
          return Scaffold(
            appBar: DAppBar(
              centerTitle: false,
              title: (state.firstStep)
                  ? LocaleKeys.createWallet.tr()
                  : LocaleKeys.confirmSecretRecoveryPhrase.tr(),
            ),
            body: Column(
              children: [
                SizedBox(
                    height: 77.h,
                    child: DCustomStepper(
                      physics: (state.firstStep)
                          ? const NeverScrollableScrollPhysics()
                          : null,
                      lineColor: AppColors.primaryPurpleColor,
                      stepSize: 30,
                      textWidth: 30.w,
                      stepperhorizontal: 10.w,
                      listOfContentText: [
                        LocaleKeys.secureWallet.tr(),
                        LocaleKeys.confirmSecretRecoveryPhrase.tr()
                      ],
                      listOfContent: [
                        Column(
                          children: [
                            Text(
                              LocaleKeys.getSetGo.tr(),
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.caption1,
                            ),
                            const SizedBox(
                              height: 18,
                            ),
                            Text(LocaleKeys.thisIsYourSecretRecoveryPhrase.tr(),
                                textAlign: TextAlign.center),
                            const SizedBox(
                              height: 18,
                            ),
                            AuthenticationGrid(
                              borderColor: AppColors.primaryPurpleColor,
                              data: state.mnemonic ?? [],
                              gridColor: AppColors.primaryPurpleColor,
                              isDisplay: true,
                              currentIndex: 0,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              LocaleKeys.lastStep.tr(),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 18,
                            ),
                            AuthenticationGrid(
                              borderColor: AppColors.baseBorderColor,
                              data: List.generate(state.mnemonic?.length ?? 0,
                                  (index) => "").toList(),
                              gridColor: AppColors.baseBorderColor,
                              isDisplay: false,
                              currentIndex: 0,
                            ),
                          ],
                        ),
                      ],
                    )),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 23),
                  child: BaseButton(
                    onTap: () {
                      context.read<AuthenticationCubit>().nextStep();
                    },
                    text: LocaleKeys.continueText.tr(),
                    backgroundColor: AppColors.primaryPurpleColor,
                    buttonWidth: 100.w,
                    buttonHeight: 47,
                    // textColor: AppColors.secondaryFontColor,
                  ),
                )
              ],
            ),
          );
        }));
      },
    );
  }
}
