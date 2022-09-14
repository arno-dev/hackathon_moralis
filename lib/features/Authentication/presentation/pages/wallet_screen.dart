import 'package:d_box/core/constants/colors.dart';
import 'package:d_box/core/widgets/base_button.dart';
import 'package:d_box/core/widgets/d_appbar.dart';
import 'package:d_box/core/widgets/d_box_alert_dialog.dart';
import 'package:d_box/core/widgets/d_box_check_box.dart';
import 'package:d_box/core/widgets/d_box_un_ordered_list.dart';
import 'package:d_box/generated/assets.gen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../cubit/authentication_cubit_cubit.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationCubit, AuthenticationState>(
      builder: (context, state) {
        return Sizer(
          builder: (context, orientation, deviceType) {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: DAppBar(title: tr('titleCloudmet'), leading: false),
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
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryPurpleColor)),
                            SizedBox(height: 5.w),
                            Text(tr('welcomeContent'),
                                textAlign: TextAlign.center)
                          ],
                        ),
                        SizedBox(height: 5.w),
                        Column(
                          children: [
                            BaseButton(
                                text: tr('importWallet'),
                                buttonWidth: 100.w,
                                backgroundColor: AppColors.primaryPurpleColor,
                                color: Colors.white,
                                buttonHeight: 13.w),
                            SizedBox(height: 3.w),
                            BaseButton(
                              text: tr('createYourWallet'),
                              buttonWidth: 100.w,
                              buttonHeight: 13.w,
                              borderColor: AppColors.primaryPurpleColor,
                              color: AppColors.primaryPurpleColor,
                              onTap: () => _dialogBuilder(context),
                            ),
                          ],
                        )
                      ],
                    )),
              )),
            );
          },
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
        child: DboxAlertDialog(title: 'Secure your wallet', content: [
          Assets.images.security.image(),
          SizedBox(height: 5.w),
          DboxUnorderedList(
            [tr('secureYourWalletListText1'), tr('secureYourWalletListText2')],
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
                  color: Colors.white,
                  buttonHeight: 13.w);
            },
          ),
          SizedBox(height: 3.w),
        ]),
      );
    },
  ).then((_) => context.read<AuthenticationCubit>().changeCheckValue(false));
}