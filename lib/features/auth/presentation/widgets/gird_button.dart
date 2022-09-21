import 'package:d_box/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/widgets/base_button.dart';
import 'dotted_button.dart';

class GridButton extends StatelessWidget {
  const GridButton(
      {super.key,
      this.text,
      this.index,
      this.isDottedButton = true,
      required this.borderColor,
      this.textColor,
      this.onTap});
  final String? text;
  final int? index;
  final bool isDottedButton;
  final Color borderColor;
  final void Function(int)? onTap;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        (index != null)
            ? SizedBox(
                width: 22,
                child: Text(
                  "$index.",
                  textAlign: TextAlign.end,
                  style: TextStyle(color: textColor),
                ),
              )
            : Container(),
        const SizedBox(
          width: 5,
        ),
        isDottedButton
            ? DottedButton(
                buttonWidth: 28.w,
                borderColor: borderColor,
                onTap: () {
                  if (onTap != null && index != null) {
                    onTap!(index!);
                  }
                })
            : BaseButton(
                text: text,
                buttonWidth: 28.w,
                textColor: AppColors.primaryPurpleColor,
                borderColor: borderColor,
                onTap: () {
                  if (onTap != null && index != null) {
                    onTap!(index!);
                  }
                },
              ),
      ],
    );
  }
}
