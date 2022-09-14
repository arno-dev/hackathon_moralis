import 'package:d_box/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class DboxTextFieldDialog extends StatelessWidget {
  final Widget icons;
  final String hintText;
  final Function onChange;
  const DboxTextFieldDialog({
    Key? key,
    required this.icons,
    required this.hintText,
    required this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (String text) {
        onChange(text);
      },
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 12.sp,
          color: AppColors.lighterGrey,
        ),
        prefixIconConstraints: BoxConstraints.loose(
          Size(8.0.w, 8.0.w),
        ),
        prefixIcon:
            Container(margin: const EdgeInsets.only(right: 8.0), child: icons),
      ),
    );
  }
}
