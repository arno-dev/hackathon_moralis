import 'package:flutter/material.dart';

import '../constants/colors.dart';

class BaseButton extends StatelessWidget {
  const BaseButton(
      {super.key,
      this.text,
      this.backgroundColor,
      this.buttonHeight = 32,
      this.buttonWidth = 116,
      this.borderRadius = 28,
      this.onTap,
      this.borderColor,
      this.horizontalPadding = 12,
      this.verticalPadding = 5,
      this.isDisabled = false});
  final String? text;
  final Color? backgroundColor;
  final double buttonHeight;
  final double? buttonWidth;
  final double borderRadius;
  final Color? borderColor;
  final double horizontalPadding;
  final double verticalPadding;
  final bool isDisabled;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(borderRadius),
      color: isDisabled ? Colors.grey : backgroundColor,
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        onTap: isDisabled ? null : onTap,
        child: Container(
          decoration: (borderColor != null)
              ? BoxDecoration(
                  border: Border.all(color: borderColor!),
                  borderRadius: BorderRadius.circular(borderRadius),
                )
              : null,
          height: buttonHeight,
          width: buttonWidth,
          child: (text != null)
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                        vertical: verticalPadding),
                    child: Text(
                      text!,
                      style: const TextStyle(color: AppColors.fontColor),
                    ),
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
