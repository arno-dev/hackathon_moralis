import 'package:flutter/material.dart';
import 'package:hackathon_moralis/core/constants/colors.dart';
import 'package:sizer/sizer.dart';

extension CustomTextTheme on TextTheme {
  TextStyle get headline1Custom => const TextStyle(
        fontSize: 96.0,
        fontFamily: "Poppins",
        color: AppColors.fontColor,
        letterSpacing: -1.5,
      );
  TextStyle get headline2Custom => const TextStyle(
        fontSize: 60.0,
        fontFamily: "Poppins",
        color: AppColors.fontColor,
        letterSpacing: -0.5,
      );
  TextStyle get headline3Custom => const TextStyle(
        fontSize: 48.0,
        fontFamily: "Poppins",
        color: AppColors.fontColor,
        letterSpacing: 0.0,
      );
  TextStyle get headline4Custom => const TextStyle(
        fontSize: 34.0,
        fontFamily: "Poppins",
        color: AppColors.fontColor,
        letterSpacing: 0.25,
      );
  TextStyle get headline5Custom => const TextStyle(
        fontSize: 24.0,
        fontFamily: "Poppins",
        color: AppColors.fontColor,
        letterSpacing: 0.0,
      );
  TextStyle get headline6Custom => const TextStyle(
        fontSize: 20.0,
        fontFamily: "Poppins",
        color: AppColors.fontColor,
        letterSpacing: 0.15,
      );
  // TextStyle get headline7Custom => TextStyle(
  //       fontSize: 12.5.sp,
  //       fontFamily: "Poppins",
  //       fontWeight: FontWeight.w400,
  //       color: AppColors.appleWhiteColor,
  //     );
  // TextStyle get headline8Custom => TextStyle(
  //       fontSize: 12.0.sp,
  //       fontFamily: "Poppins",
  //       fontWeight: FontWeight.w400,
  //       color: AppColors.appleWhiteColor,
  //     );
  TextStyle get headline8CustomNoColor => TextStyle(
        fontSize: 12.0.sp,
        fontFamily: "Poppins",
        fontWeight: FontWeight.w400,
      );
  TextStyle get headline9Custom => const TextStyle(
        fontSize: 20.0,
        fontFamily: "Poppins",
        color: AppColors.fontColor,
        letterSpacing: 0.15,
        fontWeight: FontWeight.w700
      );
  TextStyle get headline10Custom => const TextStyle(
      fontSize: 24.0,
      fontFamily: "Poppins",
      color: AppColors.fontColor,
      fontWeight: FontWeight.w700);
  TextStyle get headline11Custom => const TextStyle(
        fontSize: 14.0,
        fontFamily: "Poppins",
        color: AppColors.fontColor,
        letterSpacing: 0.15,
        fontWeight: FontWeight.w700
      );
  // TextStyle get headerTitleCustom => TextStyle(
  //       fontSize: SizerUtil.deviceType == DeviceType.tablet ? 9.sp : 11.8.sp,
  //       fontFamily: "Poppins",
  //       fontWeight: FontWeight.w400,
  //       color: AppColors.appleWhiteColor,
  //     );
  // TextStyle get bodyTextCustom => TextStyle(
  //       fontSize: SizerUtil.deviceType == DeviceType.tablet ? 7.5.sp : 10.8.sp,
  //       fontFamily: "Poppins",
  //       fontWeight: FontWeight.w400,
  //       color: AppColors.disableColor,
  //     );
  TextStyle get errHintText => TextStyle(
        fontSize: SizerUtil.deviceType == DeviceType.tablet ? 6.sp : 8.sp,
        fontFamily: "Poppins",
        fontWeight: FontWeight.w400,
        color: Colors.red,
      );
  TextStyle get subtitle1Custom => const TextStyle(
        fontSize: 16.0,
        fontFamily: "Poppins",
        color: AppColors.fontColor,
        letterSpacing: 0.15,
      );
  TextStyle get subtitle1CustomBlack => const TextStyle(
        fontSize: 16.0,
        fontFamily: "Poppins",
        color: Colors.black,
        letterSpacing: 0.15,
      );
  TextStyle get subtitle2Custom => const TextStyle(
        fontSize: 14.0,
        fontFamily: "Poppins",
        color: AppColors.fontColor,
        letterSpacing: 0.1,
      );
  TextStyle get subtitle2CustomBlack => const TextStyle(
        fontSize: 14.0,
        fontFamily: "Poppins",
        color: Colors.black,
        letterSpacing: 0.1,
      );
  TextStyle get subtitle3CustomAccent => TextStyle(
        fontSize: 11.0.sp,
        fontFamily: "Poppins",
        color: AppColors.accentColor,
      );
  TextStyle get subtitle4Custom => TextStyle(
        fontSize: 10.5.sp,
        fontFamily: "Poppins",
        color: Colors.white,
      );
  TextStyle get subtitle4CustomGrey => TextStyle(
        fontSize: 10.5.sp,
        fontFamily: "Poppins",
        color: Colors.grey[400],
      );
  TextStyle get subtitle5Custom => const TextStyle(
        fontSize: 14.0,
        fontFamily: "Poppins",
        color: Colors.white,
      );
  TextStyle get subtitle6Custom => TextStyle(
        fontSize: 10.0.sp,
        fontFamily: "Poppins",
        color: Colors.white,
      );
  TextStyle get subtitle6CustomGrey => TextStyle(
        fontSize: 10.0.sp,
        fontFamily: "Poppins",
        color: Colors.white70,
      );
  TextStyle get bodyText1Custom => const TextStyle(
        fontSize: 16.0,
        fontFamily: "Poppins",
        color: AppColors.fontColor,
        letterSpacing: 0.5,
      );
  TextStyle get bodyText1CustomGrey => const TextStyle(
        fontSize: 16.0,
        fontFamily: "Poppins",
        color: Colors.grey,
        letterSpacing: 0.5,
      );
  TextStyle get bodyText2Custom => const TextStyle(
        fontSize: 14.0,
        fontFamily: "Poppins",
        color: AppColors.fontColor,
        letterSpacing: 0.25,
      );
  TextStyle get bodyText2CustomGreyNotSpacing => const TextStyle(
        fontSize: 14.0,
        fontFamily: "Poppins",
        color: Colors.grey,
      );
  TextStyle get bodyText2CustomNotSpacing => const TextStyle(
        fontSize: 14.0,
        fontFamily: "Poppins",
        color: AppColors.fontColor,
      );
  TextStyle get bodyText2CustomGrey => const TextStyle(
        fontSize: 14.0,
        fontFamily: "Poppins",
        color: Colors.grey,
        letterSpacing: 0.25,
      );
  TextStyle get bodyText2CustomBlack => const TextStyle(
        fontSize: 14.0,
        fontFamily: "Poppins",
        color: Colors.black,
        letterSpacing: 0.25,
      );
  TextStyle get bodyText3Custom => const TextStyle(
        fontSize: 12.0,
        fontFamily: "Poppins",
        color: AppColors.fontColor,
        letterSpacing: 0.15,
      );
  TextStyle get bodyText3CustomNotSpacing => const TextStyle(
        fontSize: 12.0,
        fontFamily: "Poppins",
        color: AppColors.fontColor,
      );
  TextStyle get bodyText4Custom => const TextStyle(
        fontSize: 10.0,
        fontFamily: "Poppins",
        color: AppColors.fontColor,
        letterSpacing: 0.1,
      );
  TextStyle get bodyText4CustomBlack => const TextStyle(
        fontSize: 10.0,
        fontFamily: "Poppins",
        color: Colors.black,
        letterSpacing: 0.1,
      );
  TextStyle get bodyText5Custom => const TextStyle(
        fontSize: 8.0,
        fontFamily: "Poppins",
        color: AppColors.fontColor,
        letterSpacing: 0.0,
      );
  TextStyle get bodyText6Custom => const TextStyle(
        fontSize: 6.0,
        fontFamily: "Poppins",
        color: AppColors.fontColor,
        letterSpacing: -0.5,
      );
  // TextStyle get bodyText7Custom => const TextStyle(
  //       fontSize: 12.0,
  //       fontFamily: "Poppins",
  //       color: AppColors.white60,
  //       fontWeight: FontWeight.w400,
  //     );
  TextStyle get bodyText8Custom => const TextStyle(
        fontSize: 12.0,
        fontFamily: "Poppins",
        color: AppColors.fontColor,
        fontWeight: FontWeight.w500,
      );
  TextStyle get bodyText9Custom => const TextStyle(
      fontSize: 14.0,
      fontFamily: "Poppins",
      color: AppColors.fontColor,
      fontWeight: FontWeight.w700);
  TextStyle get bodyText10Custom => const TextStyle(
      fontSize: 12.0,
      fontFamily: "Poppins",
      color: AppColors.accentColor,
      fontWeight: FontWeight.w500);
  TextStyle get bodyText11Custom => const TextStyle(
      fontSize: 10.0,
      fontFamily: "Poppins",
      color: AppColors.accentColor,
      fontWeight: FontWeight.w400);
  // TextStyle get bodyText12Custom => const TextStyle(
  //     fontSize: 16.0,
  //     fontFamily: "Poppins",
  //     color: AppColors.white60,
  //     fontWeight: FontWeight.w400);
  TextStyle get bodyText13Custom => const TextStyle(
      fontSize: 16.0,
      fontFamily: "Poppins",
      color: AppColors.fontColor,
      fontWeight: FontWeight.w700);
  TextStyle get bodyText14Custom => const TextStyle(
      fontSize: 12.0,
      fontFamily: "Poppins",
      color: AppColors.fontColor,
      fontWeight: FontWeight.w700);
  // TextStyle get bodyText15Custom => const TextStyle(
  //     fontSize: 10.0,
  //     fontFamily: "Poppins",
  //     color: AppColors.white60,
  //     fontWeight: FontWeight.w400);
  TextStyle get buttonCustom => const TextStyle(
        fontSize: 14.0,
        fontFamily: "Poppins",
        color: AppColors.fontColor,
        letterSpacing: 1.25,
      );
  TextStyle get captionCustom => const TextStyle(
        fontSize: 12.0,
        fontFamily: "Poppins",
        color: AppColors.fontColor,
        letterSpacing: 0.4,
      );
  TextStyle get overlineCustom => const TextStyle(
        fontSize: 10.0,
        fontFamily: "Poppins",
        color: AppColors.fontColor,
        letterSpacing: 1.5,
      );
}
