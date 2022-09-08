import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../generated/locale_keys.g.dart';
import '../../domain/entities/todos.dart';
import '../../domain/entities/user.dart';
import '../cubit/todo_cubit.dart';

class TodosPage extends StatelessWidget {
  const TodosPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.todosTitle.tr()),
        bottom: TabBar(
          controller: context.read<TodoCubit>().tabController,
          tabs: const [
            Tab(icon: Icon(Icons.list)),
            Tab(icon: Icon(Icons.person)),
          ],
        ),
      ),
      body: BlocBuilder<TodoCubit, TodoState>(
        builder: (context, state) {
          return state.when(start: () {
            return const SizedBox();
          }, loading: () {
            return const Center(child: CircularProgressIndicator());
          }, loaded: (todos, users) {
            return TabBarView(
                controller: context.read<TodoCubit>().tabController,
                children: [
                  ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8),
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      Todos todo = todos[index];
                      return Text(todo.titleEntity);
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider();
                    },
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8),
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      User user = users[index];
                      return ListTile(
                        onTap: () {
                          context
                              .read<TodoCubit>()
                              .onUserClick(user.websiteEntity);
                        },
                        title: Text(user.nameEntity),
                        subtitle: Text(
                          "company:${user.companyEntity.nameEntity} \ncatch:${user.companyEntity.catchPhraseEntity} \nemail:${user.emailEntity} \nphone:${user.phoneEntity} \ncity:${user.addressEntity.cityEntity} \nstreet:${user.addressEntity.streetEntity}",
                        ),
                        isThreeLine: true,
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider();
                    },
                  ),
                ]);
          }, error: (error) {
            return Center(
              child: Text(
                error,
                style: Theme.of(context).textTheme.displaySmall,
              ),
            );
          });
        },
      ),
    );
  }
}
