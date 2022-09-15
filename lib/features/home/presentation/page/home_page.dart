import 'dart:io';

import 'package:d_box/core/constants/data_status.dart';
import 'package:d_box/features/home/domain/entities/images_from_link.dart';
import 'package:d_box/features/home/presentation/cubit/cubit/push_notification_cubit.dart';
import 'package:d_box/features/home/presentation/widgets/custom_button_recent.dart';
import 'package:d_box/features/home/presentation/widgets/emtry_file.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
          Assets.icons.user.svg(),
          const SizedBox(width: 10),
          Assets.icons.notification.svg(),
          const SizedBox(width: 10)
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
        backgroundColor: const Color(0xFFA24FFD),
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
                                ? RootFolderView(recents: recents)
                                : ChildFolderView(
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
