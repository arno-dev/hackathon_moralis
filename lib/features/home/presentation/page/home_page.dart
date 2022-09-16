import 'dart:io';

import 'package:d_box/core/constants/data_status.dart';
import 'package:d_box/features/home/domain/entities/images_from_link.dart';
import 'package:d_box/features/home/presentation/cubit/account/my_account_cubit.dart';
import 'package:d_box/features/home/presentation/cubit/cubit/push_notification_cubit.dart';
import 'package:d_box/features/home/presentation/widgets/d_box_switch.dart';
import 'package:flutter/services.dart';
import 'package:d_box/features/home/presentation/widgets/custom_button_recent.dart';
import 'package:d_box/features/home/presentation/widgets/emtry_file.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:no_context_navigation/no_context_navigation.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/services/navigation.dart';
import '../../../../core/widgets/base_button.dart';
import '../../../../core/widgets/d_appbar.dart';
import '../../../../core/widgets/d_box_alert_dialog.dart';
import '../../../../core/widgets/d_box_button_bottom_sheet.dart';
import '../../../../core/widgets/d_box_textfield.dart';
import '../../../../core/widgets/d_box_textfield_dialog.dart';
import '../../../../generated/assets.gen.dart';
import '../cubit/Home/home_cubit.dart';
import '../widgets/child_folder_view.dart';
import '../widgets/root_folder.view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DAppBar(
        title: "My Cloundmet",
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
          Navigation.bottomSheetModel(context, [
            DboxButtonBottomSheet(
              label: 'Upload Photos',
              onTap: () async {
                await context.read<HomeCubit>().onPickImages();
                Navigator.pop(context);
              },
            ),
            DboxButtonBottomSheet(
              label: 'Take Photos',
              onTap: () {
                // _dialogBuilder(context);
              },
            ),
            DboxButtonBottomSheet(
              label: 'Upload files',
              onTap: () {},
            ),
            Platform.isIOS
                ? const SizedBox(height: 20)
                : const SizedBox.shrink()
          ]);
        },
        backgroundColor: AppColors.primaryPurpleColor,
        child: const Icon(
          Icons.add,
          size: 30,
        ),
      ),
      body: BlocBuilder<PushNotificationCubit, PushNotificationState>(
        builder: (context, state) {
          return BlocConsumer<HomeCubit, HomeState>(
            listener: ((context, state) {
              if (state.listImages != null) {
                _dialogBuilder(context: context);
              }
            }),
            listenWhen: ((previous, current) {
              return previous.listImages != current.listImages;
            }),
            builder: (context, state) {
              if (state.dataStatus == DataStatus.initial) {
                return const SizedBox();
              } else if (state.dataStatus == DataStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state.dataStatus == DataStatus.loaded) {
                List<ImagesFromLink>? recents = state.recents ?? [];
                return SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DboxTextField(
                          hintText: 'Search your files',
                          isSearch: true,
                          controller:
                              context.read<HomeCubit>().searchController,
                        ),
                        state.stack.isNotEmpty
                            ? TextButton(
                                onPressed: () {
                                  context.read<HomeCubit>().onBackFolder();
                                },
                                child: const Text("..."))
                            : CustomButtonRecent(
                                onPressed: () {},
                              ),
                        recents.isNotEmpty
                            ? state.stack.isEmpty
                                ? RootFolderView(recents: recents, onTap: (index, rootIndex) { 
                                   if (state.recents?[rootIndex] != null &&
                                          state.recents?[rootIndex].filetreeEntity?.childrenEntity?[index].isFolderEntity == true) {
                                        context.read<HomeCubit>().onOpenFolder(
                                            childIndex: index,
                                            rootIndex: rootIndex);
                                      }

                                },)
                                : ChildFolderView(
                                    onTap: (int index, int rootIndex) {
                                      if (state.currentFolder != null &&
                                          state.currentFolder![index]
                                              .isFolderEntity) {
                                        context.read<HomeCubit>().onOpenFolder(
                                            childIndex: index,
                                            rootIndex: rootIndex);
                                      }
                                    },
                                    folders: state.currentFolder,
                                    modified: state.recents![state.stack[0]]
                                        .createdAtEntity,
                                    rootIndex: state.stack[0])
                            : const EmtryFileWidget(),
                      ],
                    ),
                  ),
                );
              } else if (state.dataStatus == DataStatus.error) {
                return Center(
                  child: Text(
                    "ERROR",
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          );
        },
      ),
    );
  }
}

Future<void> _dialogBuilder({
  required BuildContext context,
  bool isAddFolder = false,
}) {
  return showDialog<void>(
    context: context,
    builder: (_) {
      return BlocProvider.value(
        value: context.read<HomeCubit>(),
        child: DboxAlertDialog(
          title: isAddFolder ? "Add to folder" : 'Send to your friend',
          titleColor: Colors.black,
          content: [
            DboxTextFieldDialog(
              hintText: "Add people",
              icons: Assets.icons.userplusicon.svg(
                width: 8.w,
                height: 8.w,
              ),
              onChange: (String text) {
                context.read<HomeCubit>().onAddPeopleChange(text);
              },
            ),
            DboxTextFieldDialog(
              hintText: "Add folder",
              icons: Assets.icons.foldericon.svg(
                width: 8.w,
                height: 8.w,
              ),
              onChange: (String text) {
                context.read<HomeCubit>().onAddFolderChange(text);
              },
            ),
            SizedBox(height: 1.w),
            Padding(
              padding: EdgeInsets.only(left: 6.w),
              child: Text(
                "*Optional",
                style: TextStyle(
                  color: AppColors.lighterGrey,
                  fontSize: 12.0.sp,
                ),
              ),
            ),
            SizedBox(height: 15.w),
            isAddFolder
                ? const SizedBox.shrink()
                : BlocSelector<HomeCubit, HomeState, String>(
                    selector: (state) {
                      return state.addPeople;
                    },
                    builder: (context, addPeople) {
                      return BaseButton(
                        text: tr('send'),
                        buttonWidth: 100.w,
                        backgroundColor: AppColors.primaryPurpleColor,
                        isDisabled: addPeople == "",
                        textColor: Colors.white,
                        buttonHeight: 6.h,
                        onTap: () async {
                          await context.read<HomeCubit>().onSaveImage();
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
            SizedBox(height: 3.w),
            BaseButton(
              text: tr('cancel'),
              onTap: () {
                context.read<HomeCubit>().onCancelDialog();
                Navigator.pop(context);
              },
              buttonWidth: 100.w,
              backgroundColor: Colors.white,
              textColor: Colors.black,
              buttonHeight: 6.h,
            ),
          ],
        ),
      );
    },
  ).then((value) {
    context.read<HomeCubit>().onCancelDialog();
  });
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

Future<void> _qrDialog(context) => showDialog<void>(
      context: context,
      builder: (context) {
        return DboxAlertDialog(
            title: tr('showThisToYourFriends'),
            contentPadding: 0,
            actionsPadding: 0,
            content: [
              SizedBox(height: 5.w),
              Center(
                child: QrImage(
                  data: "1234567890",
                  version: QrVersions.auto,
                  size: 200.0,
                ),
              ),
              SizedBox(height: 5.w),
              Center(
                child: BaseButton(
                    onTap: () {},
                    text: tr('save'),
                    buttonWidth: 50.w,
                    backgroundColor: AppColors.primaryPurpleColor,
                    textColor: Colors.white,
                    buttonHeight: 13.w),
              ),
              SizedBox(height: 5.w)
            ]);
      },
    );
