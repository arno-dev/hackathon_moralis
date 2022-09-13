import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../features/home/presentation/cubit/Home/home_cubit.dart';
import '../../../features/home/presentation/page/home_page.dart';
import '../../../features/todo/presentation/cubit/todo_cubit.dart';
import '../../../features/todo/presentation/pages/todos_page.dart';
import '../DI/configure_dependencies.dart';

class AppRoute {
  static const String initialRoute = "/";
  static const String todosRoute = "/todos";
  static Route<dynamic>? routeGenerate(
      RouteSettings settings, TickerProvider tickerProvider) {
    switch (settings.name) {
      case initialRoute:
        return MaterialPageRoute(
            // hard code link for test
            builder: (_) => BlocProvider(
                  create: (context) => getIt<HomeCubit>()
                  // ..getUserFromLink('_8Plp_fn71Rf70cp8b65-'),
                  ,
                  child: const HomePage(),
                ));
      case todosRoute:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) =>
                getIt<TodoCubit>(param1: tickerProvider)..getTodos(),
            child: const TodosPage(),
          ),
          fullscreenDialog: true,
        );
      default:
        return null;
    }
  }
}
