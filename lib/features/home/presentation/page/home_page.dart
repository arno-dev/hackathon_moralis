import 'package:d_box/core/constants/data_status.dart';
import 'package:d_box/features/home/presentation/widgets/custom_button_recent.dart';
import 'package:d_box/features/home/presentation/widgets/emtry_file.dart';
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
            List<Images>? folders = state.currentFolder ?? [];
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
                    folders.length > 0
                        ? Expanded(
                            child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                              ),
                              itemCount: folders.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () {},
                                  child: Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        folders[index].isFolderEntity
                                            ? const Icon(
                                                Icons.folder,
                                                size: 100,
                                              )
                                            : const Icon(Icons.image),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          folders[index].nameEntity,
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : const EmtryFileWidget(),
                    Text("End")
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
          return SizedBox.shrink();
        },
      ),
    );
  }
}
