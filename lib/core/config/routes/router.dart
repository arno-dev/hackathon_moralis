import 'package:d_box/features/home/presentation/page/detail_page.dart';
import 'package:d_box/features/home/presentation/page/alerts_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../features/auth/presentation/cubit/authentication_cubit_cubit.dart';
import '../../../features/auth/presentation/pages/authentication_screen.dart';
import '../../../features/auth/presentation/pages/congratulations_screen.dart';
import '../../../features/auth/presentation/pages/import_wallet_screen.dart';
import '../../../features/auth/presentation/pages/wallet_screen.dart';
import '../../../features/home/presentation/cubit/Home/home_cubit.dart';
import '../../../features/home/presentation/cubit/alerts/alerts_cubit.dart';
import '../../../features/home/presentation/cubit/detail/detail_cubit.dart';
import '../../../features/home/presentation/cubit/push_notification/push_notification_cubit.dart';
import '../../../features/home/presentation/page/home_page.dart';
import '../DI/configure_dependencies.dart';

class AppRoute {
  static const String initialRoute = "/";
  static const String importWalletRoute = "/importWallet";
  static const String createWalletRoute = "/createWallet";
  static const String congratulationsRoute = "/congratulations";
  static const String homeRoute = "/home";
  static const String notifications = "/notifications";
  static const String detailRoute = "/detail";
  static Route<dynamic>? routeGenerate(
      RouteSettings settings, TickerProvider tickerProvider) {
    switch (settings.name) {
      case initialRoute:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => getIt<AuthenticationCubit>(),
                  child: const WalletPage(),
                ));
      case importWalletRoute:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => getIt<AuthenticationCubit>(),
                  child: const ImportWalletPage(),
                ));
      case createWalletRoute:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) =>
                      getIt<AuthenticationCubit>()..getMnemonicData(),
                  child: const AuthenticationScreen(),
                ));
      case congratulationsRoute:
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
                  ],
                  child: const HomePage(),
                ));
      case notifications:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => getIt<AlertsCubit>()..getAlerts(),
                  child: const AlertsPage(),
                ));
      case detailRoute:
        String? link = settings.arguments as String?;
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (context) =>
                          getIt<DetailCubit>()..getUserFromLink(link ?? ""),
                    ),
                  ],
                  child: const DetailPage(),
                ));
      default:
        return null;
    }
  }
}
