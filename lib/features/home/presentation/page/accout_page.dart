import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:no_context_navigation/no_context_navigation.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/util/navigation.dart';
import '../../../../core/widgets/d_box_alert_dialog.dart';
import '../../../../generated/assets.gen.dart';
import '../../../../generated/locale_keys.g.dart';
import '../cubit/account/my_account_cubit.dart';
import '../widgets/d_box_switch.dart';
import '../widgets/qr_dialog_view.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocSelector<MyAccountCubit, MyAccountState, String?>(
      selector: (state) {
        return state.errorMessage;
      },
      builder: (context, errorMessage) {
        return errorMessage != null
            ? Center(
                child: Text(
                  errorMessage,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              )
            : DboxAlertDialog(
                title: tr('myAccount'),
                contentPadding: 0,
                actionsPadding: 0,
                content: [
                    SizedBox(height: 2.w),
                    Container(
                      padding: const EdgeInsets.all(29),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: BlocSelector<MyAccountCubit, MyAccountState,
                                String>(
                              selector: (state) {
                                return state.qrCode;
                              },
                              builder: (context, qrCode) {
                                return Column(
                                  children: [
                                    InkWell(
                                      highlightColor:
                                          AppColors.disAbleButtonColor,
                                      splashColor: AppColors.transparentColor,
                                      onTap: () {
                                        Clipboard.setData(
                                            ClipboardData(text: qrCode));
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Expanded(
                                            flex: 4,
                                            child: Text(
                                              qrCode,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.start,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1,
                                            ),
                                          ),
                                          const Spacer(),
                                          Assets.icons.document.svg()
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.w,
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: InkWell(
                                        splashColor: AppColors.transparentColor,
                                        splashFactory: NoSplash.splashFactory,
                                        highlightColor:
                                            AppColors.transparentColor,
                                        hoverColor: AppColors.transparentColor,
                                        child: Text(LocaleKeys.myQrCode.tr()),
                                        onTap: () {
                                          navService.goBack();
                                          Navigation.dBoxShowDialog(
                                            context,
                                            QrDialogView(
                                              screenshotController: context
                                                  .read<MyAccountCubit>()
                                                  .screenshotController,
                                              qrCode: qrCode,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            height: 5.w,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(LocaleKeys.pushNotification.tr()),
                                BlocSelector<MyAccountCubit, MyAccountState,
                                    bool>(
                                  selector: (state) {
                                    return state.isPushNotifacationChecked;
                                  },
                                  builder:
                                      (context, isPushNotifacationChecked) {
                                    return Transform.scale(
                                        scale: 0.2.w,
                                        child: DboxSwitch(
                                            value: isPushNotifacationChecked,
                                            onChanged: (value) {
                                              context
                                                  .read<MyAccountCubit>()
                                                  .changeSwitchPushNotification(
                                                      value);
                                            }));
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5.w,
                          ),
                          SizedBox(
                            height: 48,
                            width: 100.w,
                            child: InkWell(
                              customBorder: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(16),
                                    bottomRight: Radius.circular(16)),
                              ),
                              highlightColor: AppColors.disAbleButtonColor,
                              splashColor: AppColors.transparentColor,
                              child: Text(
                                LocaleKeys.logout.tr(),
                                style: const TextStyle(
                                    color: AppColors.accentColor),
                              ),
                              onTap: () {
                                navService.goBack();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]);
      },
    );
  }
}
