import 'package:flutter/material.dart';
import 'package:hackathon_moralis/core/constants/colors.dart';

class AppTheme {

  static ThemeData get mainTheme{
    return ThemeData(
      primaryColor: AppColors.primaryColor,
      primarySwatch: AppColors.primarySwatchColor,
      textTheme: const TextTheme (
      headline1: TextStyle(color: AppColors.primaryColor),
      headline2: TextStyle(color: AppColors.primaryColor),
      bodyText2: TextStyle(color: AppColors.accentColor),
      subtitle1: TextStyle(color: AppColors.subColor),
      )
    );
  }
}