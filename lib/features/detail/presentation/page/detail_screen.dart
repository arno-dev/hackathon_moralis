
import '../../../../core/config/themes/app_text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:no_context_navigation/no_context_navigation.dart';
import '../../../../core/config/routes/router.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/data_status.dart';
import '../../../../core/widgets/d_appbar.dart';
import '../../../../core/widgets/loading.dart';
import '../../../../generated/assets.gen.dart';
import '../../../home/presentation/widgets/child_folder_view.dart';
import '../../../home/presentation/widgets/emtry_file.dart';
import '../cubit/detail_cubit.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DAppBar(
        title: "My Cloundmet",
        titleColor: AppColors.primaryColor,
        backgroundColor: AppColors.subAppbarColor,
        centerTitle: false,
        onTap: () => navService.pushNamedAndRemoveUntil(AppRoute.homeRoute),
      ),
      body: BlocBuilder<DetailCubit,DetailState>(builder: ((context, state) {
            if (state.dataStatus == DataStatus.initial) {
                return const SizedBox();
              } else if (state.dataStatus == DataStatus.loading || state.dataStatus == DataStatus.opening) {
                return const LoadingWidget();
              } else if (state.dataStatus == DataStatus.loaded) {
                String stackName = state.stackName.isNotEmpty ? state.stackName.last :"";
                return SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                         if(stackName != "")   InkWell(
                                onTap:  (state.stack.length >=2) ?   () {
                                  context.read<DetailCubit>().onBackFolder();
                                } : null,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                  if (state.stack.length >=2)   Assets.icons.backward.svg(
                                      color: AppColors.disAbleColor,
                                      width: 10.0,
                                      height: 10.0,
                                    ),
                                 const SizedBox(width: 5),
                                      Text(stackName,
                                        style: Theme.of(context)
                                            .textTheme
                                            .customText7),
                                  ],
                                ),
                              ),
                        const SizedBox(
                          height: 10,
                        ),
                        state.imagesFromLink != null
                            ?
                        ChildFolderView(
                                    onTap: (int index, int rootIndex) async {
                                      if (state.currentFolder != null &&
                                          state.currentFolder![index]
                                              .isFolderEntity) {
                                        context.read<DetailCubit>().onOpenFolder(
                                            childIndex: index,
                                            rootIndex: rootIndex);
                                      } else{
                                          await context
                                            .read<DetailCubit>()
                                            .onPreview(
                                                rootIndex: rootIndex,
                                                childIndex: index);
                                      }

                                    },
                                    folders: state.currentFolder,
                                    modified: state.recents![0]
                                        .createdAtEntity,
                                    rootIndex: 0)
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
            
          })),
    );
  }
}

