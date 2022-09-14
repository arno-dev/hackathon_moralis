import 'package:d_box/core/config/routes/router.dart';
import 'package:d_box/core/constants/data_status.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:no_context_navigation/no_context_navigation.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/widgets/d_appbar.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../core/config/themes/app_text_theme.dart';
import '../cubit/authentication_cubit_cubit.dart';
import '../widgets/authenticate_grid_view.dart';
import '../widgets/authentication_grid.dart';
import '../widgets/d_stepper.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  late NotificationService notificationService;

  @override
  void initState() {
    super.initState();
    notificationService = NotificationService(
        FlutterLocalNotificationsPlugin(), FirebaseMessaging.instance);
    notificationService.initializePlatformNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationCubit, AuthenticationState>(
      builder: (context, state) {
        return Scaffold(
          appBar: DAppBar(
            onTap: () => (state.firstStep)
                ? navService.goBack()
                : context.read<AuthenticationCubit>().firstStep(true),
            centerTitle: false,
            title: (state.firstStep)
                ? LocaleKeys.createWallet.tr()
                : LocaleKeys.confirmSecretRecoveryPhrase.tr(),
          ),
          body: DCustomStepper(
            isValidated: state.firstStep
                ? false
                : (state.newMnemonic!.contains("") || state.firstStep),
            onTap: (state.firstStep || !state.newMnemonic!.contains(""))
                ? (index) async {
                    if (index == 0) {
                      context.read<AuthenticationCubit>().firstStep(false);
                    } else {
                    await context
                          .read<AuthenticationCubit>()
                          .saveCredential();
                     if(state.mnemonic.toString() == state.newMnemonic.toString()) navService.pushNamedAndRemoveUntil(AppRoute.congratulations);
                    }
                  }
                : null,
            lineColor: AppColors.primaryPurpleColor,
            currentIndex: (state.firstStep) ? 0 : 1,
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
                  BlocProvider.value(
                    value: context.read<AuthenticationCubit>(),
                    child: AuthenticateGridView(
                      isValidated: state.dataStatus == DataStatus.error,
                      dataList: state.newMnemonic ?? [],
                      onRemove: (index) {
                        context
                            .read<AuthenticationCubit>()
                            .updateNewMnemonic(index);
                      },
                      onAdd: (index) {
                        context
                            .read<AuthenticationCubit>()
                            .updateNewMnemonic(index, isAdding: true);
                      },
                    ),
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
