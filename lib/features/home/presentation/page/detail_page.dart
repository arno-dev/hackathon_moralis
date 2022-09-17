import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:no_context_navigation/no_context_navigation.dart';
import '../../../../core/config/routes/router.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/data_status.dart';
import '../../../../core/widgets/d_appbar.dart';
import '../../../../core/widgets/loading.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../domain/entities/images.dart';
import '../../domain/entities/images_from_link.dart';
import '../cubit/detail/detail_cubit.dart';
import '../widgets/detail_view.dart';
import '../widgets/error_view.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DAppBar(
        title: LocaleKeys.myCloundmet.tr(),
        titleColor: AppColors.primaryColor,
        backgroundColor: AppColors.subAppbarColor,
        centerTitle: false,
        onTap: () => navService.pushNamedAndRemoveUntil(AppRoute.homeRoute),
      ),
      body: BlocConsumer<DetailCubit, DetailState>(
        listener: (context, state) async {
          if (state.errorMessage != null) {
            await context.read<DetailCubit>().onDismissErorr();
          }
        },
        builder: ((context, state) {
          if (state.dataStatus == DataStatus.loading ||
              state.dataStatus == DataStatus.opening) {
            return const LoadingWidget();
          } else {
            String stackName =
                state.stackName.isNotEmpty ? state.stackName.last : "";
            List<int> stack = state.stack;
            ImagesFromLink? imagesFromLink = state.imagesFromLink;
            List<Images> currentFolder = state.currentFolder ?? [];
            List<ImagesFromLink> recents = state.recents ?? [];
            return DetailView(
              stackName: stackName,
              stack: stack,
              imagesFromLink: imagesFromLink,
              currentFolder: currentFolder,
              recents: recents,
              onBackFolder: () => context.read<DetailCubit>().onBackFolder(),
              onOpenFolder: (rootIndex, index) => context
                  .read<DetailCubit>()
                  .onOpenFolder(childIndex: index, rootIndex: rootIndex),
              onPreview: (rootIndex, index) async => await context
                  .read<DetailCubit>()
                  .onPreview(rootIndex: rootIndex, childIndex: index),
            );
          }
        }),
      ),
      bottomNavigationBar: BlocSelector<DetailCubit, DetailState, String?>(
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
