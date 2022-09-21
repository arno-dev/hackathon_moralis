import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:no_context_navigation/no_context_navigation.dart';
import '../../../../core/config/DI/configure_dependencies.dart';
import '../../../../core/config/routes/router.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/data_status.dart';
import '../../../../core/constants/pick_file_type.dart';
import '../../../../core/util/navigation.dart';
import '../../../../core/widgets/d_appbar.dart';
import '../../../../core/widgets/loading.dart';
import '../../../../generated/assets.gen.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../domain/entities/images.dart';
import '../../domain/entities/images_from_link.dart';
import '../cubit/Home/home_cubit.dart';
import '../cubit/account/my_account_cubit.dart';
import '../cubit/push_notification/push_notification_cubit.dart';
import '../widgets/add_info_view.dart';
import '../widgets/error_view.dart';
import '../widgets/main_view.dart';
import '../widgets/share_bottom_sheet.dart';
import '../widgets/upload_buttom_sheet.dart';
import 'accout_page.dart';

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
            onPressed: () => Navigation.dBoxShowDialog(
              context,
              BlocProvider(
                create: (context) => getIt<MyAccountCubit>()..getMyQrCode(),
                child: const AccountPage(),
              ),
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: Assets.icons.notification.svg(),
            onPressed: () {
              navService.pushNamed(AppRoute.notifications);
            },
          ),
          const SizedBox(width: 10),
        ],
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
          listener: ((context, state) async {
            if (state.isHasImage) {
              Navigation.bottomSheetModel(
                context,
                ShareBottomSheetWidget(
                  onUploadToCloud: () async {
                    await context.read<HomeCubit>().onSaveImage();
                  },
                  onAddAddress: () {
                    Navigation.dBoxShowDialog(
                      context,
                      AddInfo(
                        isAddFolder: false,
                        onSaveImage: () async {
                          await context.read<HomeCubit>().onSaveImage();
                        },
                        addFolderController:
                            context.read<HomeCubit>().addFolderController,
                        addPeopleController:
                            context.read<HomeCubit>().addPeopleController,
                        isDisableSend: state.isDisableUpload,
                      ),
                    );
                  },
                  onScanQrCode: (qrCode) {
                    context.read<HomeCubit>().onQrCode(qrCode.toString());
                  },
                ),
              );
            }

            if (state.isHasQrAddress) {
              Navigation.dBoxShowDialog(
                context,
                AddInfo(
                  isAddFolder: true,
                  addFolderController:
                      context.read<HomeCubit>().addFolderController,
                  addPeopleController:
                      context.read<HomeCubit>().addPeopleController,
                  onSaveImage: () async {
                    await context.read<HomeCubit>().onSaveImage();
                  },
                  isDisableSend: state.isDisableUpload,
                ),
              );
            }

            if (state.errorMessage != null) {
              await context.read<HomeCubit>().onDismissErorr();
            }
          }),
          listenWhen: ((previous, current) {
            return previous.isHasImage != current.isHasImage ||
                previous.isHasQrAddress != current.isHasQrAddress ||
                previous.errorMessage != current.errorMessage;
          }),
          builder: (context, state) {
            if (state.dataStatus == DataStatus.loading) {
              return const LoadingWidget();
            } else {
              List<ImagesFromLink>? recents = state.recents ?? [];
              List<Images> currentFolder = state.currentFolder ?? [];
              List<int> stack = state.stack;
              String name =
                  state.nameStack.isNotEmpty ? state.nameStack.last : "";
              return MainView(
                stack: stack,
                name: name,
                recents: recents,
                currentFolder: currentFolder,
                searchController: context.read<HomeCubit>().searchController,
                onBackFolder: () => context.read<HomeCubit>().onBackFolder(),
                onOpenFolder: (rootIndex, childIndex) => context
                    .read<HomeCubit>()
                    .onOpenFolder(rootIndex: rootIndex, childIndex: childIndex),
                onPreview: (rootIndex, childIndex) async => await context
                    .read<HomeCubit>()
                    .onPreview(rootIndex: rootIndex, childIndex: childIndex),
              );
            }
          },
        ),
      ),
      floatingActionButton: BlocSelector<HomeCubit, HomeState, DataStatus>(
        selector: (state) {
          return state.dataStatus;
        },
        builder: (context, dataStatus) {
          return dataStatus == DataStatus.loaded
              ? FloatingActionButton(
                  onPressed: () {
                    context.read<HomeCubit>().onCancelDialog();
                    Navigation.bottomSheetModel(
                      context,
                      UploadBottomSheetWidget(
                        onTakePhoto: () async {
                          await context
                              .read<HomeCubit>()
                              .onPickImages(PickFileType.takePhoto);
                        },
                        onUploadFiles: () async {
                          await context
                              .read<HomeCubit>()
                              .onPickImages(PickFileType.files);
                        },
                        onUploadPhotos: () async {
                          await context
                              .read<HomeCubit>()
                              .onPickImages(PickFileType.photos);
                        },
                      ),
                    );
                  },
                  backgroundColor: AppColors.primaryPurpleColor,
                  child: const Icon(
                    Icons.add,
                    size: 30,
                  ),
                )
              : const SizedBox.shrink();
        },
      ),
      bottomNavigationBar: BlocSelector<HomeCubit, HomeState, String?>(
        selector: (state) {
          return state.errorMessage;
        },
        builder: (context, errorMessage) {
          return ErrorView(
            errorMessage: errorMessage,
          );
        },
      ),
    );
  }
}
