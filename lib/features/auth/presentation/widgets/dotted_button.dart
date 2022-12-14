
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import '../../../../core/widgets/base_button.dart';

class DottedButton extends StatelessWidget {
  const DottedButton( {super.key,
      this.backgroundColor,
       this.buttonHeight =32,
      this.buttonWidth = 116,
      this.borderRadius = 28,
      this.onTap,
      required this.borderColor,
      this.horizontalPadding = 0,
      this.verticalPadding = 0,
      this.strokeWidth =3});
  final Color? backgroundColor;
  final double buttonHeight;
  final double? buttonWidth;
  final double borderRadius;
  final Color borderColor;
  final double horizontalPadding;
  final double verticalPadding;
  final double strokeWidth;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return    DottedBorder(
                  color: borderColor,
                  strokeWidth: strokeWidth,
                  dashPattern: const [4, 2],
                  padding: const EdgeInsets.all(0),
                  borderType: BorderType.RRect,
                  radius:  Radius.circular(borderRadius),
                  child: BaseButton(
              
                  buttonHeight:buttonHeight,
                  buttonWidth: buttonWidth,
                  backgroundColor: backgroundColor,
                  borderRadius: borderRadius,
                  onTap: onTap,
                ),
                );
  }
}