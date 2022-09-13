import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/d_appbar.dart';
import '../../../../generated/assets.gen.dart';
import '../../../../widgets/dboxTextField.dart';
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
          return state.when(initial: () {
            return const SizedBox();
          }, start: () {
            return const SizedBox();
          }, loading: () {
            return const Center(child: CircularProgressIndicator());
          }, loaded: (imagesFromLink) {
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
                    TextButton(
                      onPressed: () {},
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Recent ",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Assets.icons.down.svg(
                            width: 6.0,
                            height: 6.0,
                          ),
                        ],
                      ),
                    ),
                    Assets.icons.recent.svg(),
                    const SizedBox(height: 40),
                    const Center(
                      child: SizedBox(
                        width: 250,
                        child: Text(
                          "Easy to send files to family, friends, and co-workers",
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            height: 1.8,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Center(
                      child: Text(
                        "After you send a file, it'll show up here.",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }, error: (String message) {
            return Center(
              child: Text(
                message,
                style: Theme.of(context).textTheme.displaySmall,
              ),
            );
          });
        },
      ),
    );
  }
}
