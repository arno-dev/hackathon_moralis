import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:no_context_navigation/no_context_navigation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/config/routes/router.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/data_status.dart';
import '../../../../core/services/navigation.dart';
import '../../../../core/widgets/base_button.dart';
import '../../../../core/widgets/d_appbar.dart';
import '../../../../core/widgets/d_box_alert_dialog.dart';
import '../../../../core/widgets/d_box_textfield.dart';
import '../../../../core/widgets/loading.dart';
import '../../../../generated/assets.gen.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../domain/entities/images_from_link.dart';
import '../cubit/Home/home_cubit.dart';
import '../cubit/account/my_account_cubit.dart';
import '../cubit/push_notification/push_notification_cubit.dart';
import '../widgets/child_folder_view.dart';
import '../widgets/custom_button_recent.dart';
import '../widgets/d_box_switch.dart';
import '../widgets/emtry_file.dart';
import '../widgets/root_folder.view.dart';
import '../widgets/share_bottom_sheet.dart';
import '../widgets/upload_buttom_sheet.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DAppBar(
        title: LocaleKeys.myCloundmet.tr(),
        titleColor: Colors.black,
        centerTitle: false,
        listOfAction: [
          IconButton(
              icon: Assets.icons.user.svg(),
              onPressed: () => _myAccountDialog(context)),
          const SizedBox(width: 10),
          IconButton(
            icon: Assets.icons.notification.svg(),
            onPressed: () {
              navService.pushNamed('/notifications');
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigation.bottomSheetModel(
            context,
            BlocProvider.value(
              value: context.read<HomeCubit>(),
              child: const UploadBottomSheetWidget(),
            ),
          );
        },
        backgroundColor: AppColors.primaryPurpleColor,
        child: const Icon(
          Icons.add,
          size: 30,
        ),
      ),
      body: BlocListener<PushNotificationCubit, PushNotificationState>(
        listener: (context, state) async {
          if (state.link != null) {
            navService
                .pushNamed(AppRoute.detailRoute, args: state.link)
                .then((_) {
              context.read<PushNotificationCubit>().resetLink();
            });
          }
        },
        child: BlocConsumer<HomeCubit, HomeState>(
          listener: ((context, state) {
              if (state.isHasImage) {
                Navigation.bottomSheetModel(
                  context,
                  BlocProvider.value(
                    value: context.read<HomeCubit>(),
                    child: const ShareBottomSheetWidget(),
                  ),
                ).then((value) => context.read<HomeCubit>().onCancelDialog());
                // _dialogBuilder(context: context);
              }
            }),
          listenWhen: ((previous, current) {
            return previous.isHasImage != current.isHasImage;
          }),
          builder: (context, state) {
            if (state.dataStatus == DataStatus.initial) {
              return const SizedBox();
            } else if (state.dataStatus == DataStatus.loading) {
              return const LoadingWidget();
            } else if (state.dataStatus == DataStatus.loaded) {
              List<ImagesFromLink>? recents = state.recents ?? [];
              String name =
                  state.nameStack.isNotEmpty ? state.nameStack.last : "";
              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DboxTextField(
                        hintText: LocaleKeys.searchYourFiles.tr(),
                        isSearch: true,
                        controller: context.read<HomeCubit>().searchController,
                      ),
                      state.stack.isNotEmpty
                          ? TextButton(
                              onPressed: () {
                                context.read<HomeCubit>().onBackFolder();
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.arrow_back_ios_new_rounded,
                                    color: AppColors.primaryColor,
                                    size: 14.sp,
                                  ),
                                  Text(
                                    name,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ))
                          : CustomButtonRecent(
                              onPressed: () {},
                            ),
                      recents.isNotEmpty
                          ? state.stack.isEmpty
                              ? RootFolderView(
                                  recents: recents,
                                  onTap: (index, rootIndex) async {
                                    if (state.recents?[rootIndex] != null &&
                                        state
                                                .recents?[rootIndex]
                                                .filetreeEntity
                                                ?.childrenEntity?[index]
                                                .isFolderEntity ==
                                            true) {
                                      context.read<HomeCubit>().onOpenFolder(
                                          childIndex: index,
                                          rootIndex: rootIndex);
                                    } else {
                                      await context.read<HomeCubit>().onPreview(
                                          rootIndex: rootIndex,
                                          childIndex: index);
                                    }
                                  },
                                )
                              : ChildFolderView(
                                  onTap: (int index, int rootIndex) async {
                                    if (state.currentFolder != null &&
                                        state.currentFolder![index]
                                            .isFolderEntity) {
                                      context.read<HomeCubit>().onOpenFolder(
                                          childIndex: index,
                                          rootIndex: rootIndex);
                                    } else {
                                      await context.read<HomeCubit>().onPreview(
                                          rootIndex: rootIndex,
                                          childIndex: index);
                                    }
                                  },
                                  folders: state.currentFolder,
                                  modified: state
                                      .recents![state.stack[0]].createdAtEntity,
                                  rootIndex: state.stack[0])
                          : const EmtryFileWidget(),
                    ],
                  ),
                ),
              );
            } else if (state.dataStatus == DataStatus.error) {
              return Center(
                child: InkWell(
                  onTap: () async {
                    await context.read<HomeCubit>().getRecents();
                  },
                  child: Text(
                    "ERROR",
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}


Future<void> _myAccountDialog(BuildContext context) => showDialog<void>(
      context: context,
      builder: (_) {
        return BlocProvider.value(
          value: context.read<MyAccountCubit>(),
          child: DboxAlertDialog(
              title: tr('myAccount'),
              contentPadding: 0,
              actionsPadding: 0,
              content: [
                SizedBox(height: 2.w),
                Center(
                    child: InkWell(
                        highlightColor: AppColors.disAbleButtonColor,
                        splashColor: AppColors.transparentColor,
                        onTap: () {
                          Clipboard.setData(const ClipboardData(
                              text: "54rrfdsfsfdsf@dasc4342624324.com"));
                        },
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text:
                                    '${"54rrfdsfsfdsf@dasc4342624324.com".substring(0, 20)}...',
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                              WidgetSpan(child: Assets.icons.document.svg()),
                            ],
                          ),
                        ))),
                Container(
                  padding: const EdgeInsets.all(29),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: InkWell(
                          splashColor: AppColors.transparentColor,
                          splashFactory: NoSplash.splashFactory,
                          highlightColor: AppColors.transparentColor,
                          hoverColor: AppColors.transparentColor,
                          child: Text(tr('myQrCode')),
                          onTap: () {
                            Navigator.pop(context);
                            context.read<MyAccountCubit>().getMyQrCode();
                            _qrDialog(context);
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
                            Text(tr('pushNotification')),
                            BlocSelector<MyAccountCubit, MyAccountState, bool>(
                              selector: (state) {
                                return state.isPushNotifacationChecked;
                              },
                              builder: (context, isPushNotifacationChecked) {
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
                            )
                          ],
                        ),
                      )
                    ],
                  ),
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
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 29, top: 10, bottom: 10),
                        child: Text(
                          tr('logout'),
                          style: const TextStyle(color: AppColors.accentColor),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ))
              ]),
        );
      },
    );

Future<void> _qrDialog(BuildContext context) => showDialog<void>(
      context: context,
      builder: (_) {
        ScreenshotController screenshotController = ScreenshotController();
        return BlocProvider.value(
          value: context.read<MyAccountCubit>(),
          child: DboxAlertDialog(
              title: tr('showThisToYourFriends'),
              contentPadding: 0,
              actionsPadding: 0,
              content: [
                SizedBox(height: 5.w),
                Center(
                  child: BlocSelector<MyAccountCubit, MyAccountState, String>(
                    selector: (state) {
                      return state.qrCode;
                    },
                    builder: (context, qrCode) {
                      return Screenshot(
                          controller: screenshotController,
                          child: QrImage(
                            data: qrCode,
                            version: QrVersions.auto,
                            size: 200.0,
                          ));
                    },
                  ),
                ),
                SizedBox(height: 5.w),
                Center(
                  child: BaseButton(
                      onTap: () {
                        screenshotController
                            .capture(delay: const Duration(milliseconds: 10))
                            .then((capturedImage) async {
                          await [Permission.storage].request();
                          var result = await ImageGallerySaver.saveImage(
                              capturedImage!,
                              name: LocaleKeys.screenshot.tr());
                          return result['filePath'];
                        });
                      },
                      text: tr('save'),
                      buttonWidth: 50.w,
                      backgroundColor: AppColors.primaryPurpleColor,
                      textColor: Colors.white,
                      buttonHeight: 13.w),
                ),
                SizedBox(height: 5.w)
              ]),
        );
      },
    );
