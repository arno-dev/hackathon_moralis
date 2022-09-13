import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../constants/colors.dart';

class AppTheme {
  static ThemeData get mainTheme {
    return ThemeData(
        primaryColor: AppColors.primaryColor,
        primarySwatch: AppColors.primarySwatchColor,
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarBrightness: Brightness.light,
          ),
        ),
        fontFamily: "SF Pro",
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
            iconSize: 40, backgroundColor: AppColors.primaryPurpleColor),
        textTheme: const TextTheme(
          headline1: TextStyle(color: AppColors.primaryColor),
          headline2: TextStyle(color: AppColors.primaryColor),
          bodyText2: TextStyle(
            fontSize: 16.0,
            color: AppColors.grey,
            letterSpacing: -.3,
            height: 1.5,
            fontWeight: FontWeight.w400,
          ),
        ));
  }
}
