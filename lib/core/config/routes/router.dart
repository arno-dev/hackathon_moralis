import 'package:d_box/features/Authentication/presentation/pages/wallet_screen.dart';
import 'package:d_box/features/home/presentation/cubit/cubit/push_notification_cubit.dart';
import 'package:d_box/features/home/presentation/page/notifications_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../features/Authentication/presentation/cubit/authentication_cubit_cubit.dart';
import '../../../features/Authentication/presentation/pages/authentication_screen.dart';
import '../../../features/Authentication/presentation/pages/congratulations_screen.dart';
import '../../../features/Authentication/presentation/pages/import_wallet_screen.dart';
import '../../../features/home/presentation/cubit/Home/home_cubit.dart';
import '../../../features/home/presentation/cubit/account/my_account_cubit.dart';
import '../../../features/home/presentation/cubit/alerts/alerts_cubit.dart';
import '../../../features/home/presentation/page/home_page.dart';
import '../../../features/todo/presentation/cubit/todo_cubit.dart';
import '../../../features/todo/presentation/pages/todos_page.dart';
import '../DI/configure_dependencies.dart';

class AppRoute {
  static const String initialRoute = "/";
  static const String importWallet = "/importWallet";
  static const String createWallet = "/createWallet";
  static const String congratulations = "/congratulations";
  static const String todosRoute = "/todos";
  static const String homeRoute = "/home";
  static const String notifications = "/notifications";
  static Route<dynamic>? routeGenerate(
      RouteSettings settings, TickerProvider tickerProvider) {
    switch (settings.name) {
      case initialRoute:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => getIt<AuthenticationCubit>(),
                  child: const WalletPage(),
                ));
      case importWallet:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => getIt<AuthenticationCubit>(),
                  child: const ImportWalletPage(),
                ));
      case createWallet:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) =>
                      getIt<AuthenticationCubit>()..getMnemonicData(),
                  child: const AuthenticationScreen(),
                ));
      case congratulations:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => getIt<AuthenticationCubit>(),
                  child: const CongratulationsPage(),
                ));
      case homeRoute:
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (context) => getIt<HomeCubit>()..getRecents(),
                    ),
                    BlocProvider(
                      create: (context) => getIt<PushNotificationCubit>()
                        ..initializeFirebaseMessaging(),
                    ),
                      BlocProvider(
                      create: (context) => getIt<MyAccountCubit>(),
                    ),
                  ],
                  child: const HomePage(),
                ));
      case notifications:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) =>
                      getIt<AlertsCubit>()..getAlerts(),
                  child: const NotificationPage(),
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
