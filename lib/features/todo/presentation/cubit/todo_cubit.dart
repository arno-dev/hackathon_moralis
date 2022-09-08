import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../domain/entities/todos.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/todos_usecase.dart';
import '../../domain/usecases/users_usecase.dart';
part 'todo_state.dart';
part 'todo_cubit.freezed.dart';

@injectable
class TodoCubit extends Cubit<TodoState> {
  final GetTodosUseCase getTodosUseCase;
  final GetUsersUseCase getUsersUseCase;
  late TabController tabController;
  TodoCubit(@factoryParam TickerProviderStateMixin tickerProvider,
      this.getTodosUseCase, this.getUsersUseCase)
      : super(const TodoState.start()) {
    tabController = TabController(length: 2, vsync: tickerProvider);
    tabController.addListener(() async {
      if (tabController.offset == 0.0) {
        tabController.animateTo(tabController.index);
        if (tabController.index == 0) {
          await getTodos();
        } else {
          await getUsers();
        }
      }
    });
  }
  Future<void> onUserClick(String link) async {
     Uri url = Uri.parse("https://www.$link");
    try {
      if (!await launchUrl(url)) {
        return emit(TodoState.error(
            LocaleKeys.laucherError.tr(args: [url.toString()])));
      }
    } on PlatformException catch (e) {
      emit(TodoState.error(e.message ?? LocaleKeys.somethingWrong.tr()));
    }
  }

  Future<void> getTodos() async {
    emit(const TodoState.loading());
    final request = await getTodosUseCase(NoParams());
    request.fold((error) => emit(TodoState.error(error.message)),
        (todos) => emit(TodoState.loaded(todos: todos)));
  }

  Future<void> getUsers() async {
    emit(const TodoState.loading());
    final request = await getUsersUseCase(NoParams());
    request.fold((error) => emit(TodoState.error(error.message)),
        (users) => emit(TodoState.loaded(users: users)));
  }

  @override
  Future<void> close() {
    tabController.dispose();
    return super.close();
  }
}
