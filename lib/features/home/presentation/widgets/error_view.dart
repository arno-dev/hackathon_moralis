import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../../generated/locale_keys.g.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({
    Key? key,
    this.errorMessage,
  }) : super(key: key);

  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: errorMessage == null ? 0 : null,
        color: AppColors.primaryPurpleColor,
        padding:
            const EdgeInsets.only(top: 16, bottom: 48, left: 16, right: 16),
        child: (() {
          if (errorMessage != null) {
            return Text(
              LocaleKeys.errorMessages_showErrorMessage
                  .tr(args: [errorMessage!]),
              textAlign: TextAlign.start,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  ?.copyWith(color: AppColors.secondaryFontColor),
            );
          } else {
            return null;
          }
        }()));
  }
}
