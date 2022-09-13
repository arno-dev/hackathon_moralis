import 'package:d_box/core/constants/data_status.dart';
import 'package:d_box/features/home/domain/entities/images_from_link.dart';
import 'package:d_box/features/home/presentation/widgets/custom_button_recent.dart';
import 'package:d_box/features/home/presentation/widgets/emtry_file.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/d_appbar.dart';
import '../../../../core/widgets/d_box_textfield.dart';
import '../../../../generated/assets.gen.dart';
import '../../domain/entities/images.dart';
import '../cubit/Home/home_cubit.dart';

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
        onPressed: () {},
        backgroundColor: const Color(0xFFA24FFD),
        child: const Icon(
          Icons.add,
          size: 30,
        ),
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
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
                      controller: context.read<HomeCubit>().searchController,
                    ),
                    CustomButtonRecent(
                      onPressed: () {},
                    ),
                    recents.isNotEmpty
                        ? Expanded(
                            child: ListView.builder(
                              itemCount: recents.length,
                              itemBuilder: (BuildContext context, int index) {
                                DateTime modified = recents[index].createdAtEntity;
                                List<Images>? folders = recents[index]
                                        .filetreeEntity
                                        ?.childrenEntity ??
                                    [];
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ...List.generate(
                                      folders.length,
                                      (index) => GestureDetector(
                                        onTap: () {},
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            folders[index].isFolderEntity
                                                ? const Icon(
                                                    Icons.folder,
                                                    size: 100,
                                                  )
                                                : const Icon(Icons.image),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  folders[index].nameEntity,
                                                  style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  'Modified ${DateFormat.yMMMd()
                                                          .format(modified)}',
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              },
                            ),
                          )
                        : const EmtryFileWidget(),
                    const Text("End")
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
      ),
    );
  }
}
