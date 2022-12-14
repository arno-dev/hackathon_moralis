import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../constants/colors.dart';

class DAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DAppBar({
    super.key,
    this.title,
    this.backgroundColor = Colors.transparent,
    this.appBarHeight = 65,
    this.elevation = 0,
    this.listOfAction,
    this.centerTitle = true,
    this.automaticallyImplyLeading = false,
    this.titleColor = AppColors.primaryFontColor,
    this.titleFontSize = 18.0,
    this.titleStyle,
    this.onTap
  });
  final String? title;
  final Color backgroundColor;
  final double appBarHeight;
  final double elevation;
  final List<Widget>? listOfAction;
  final bool centerTitle;
  final bool automaticallyImplyLeading;
  final Color titleColor;
  final TextStyle? titleStyle;
  final double titleFontSize;
  final void Function()? onTap;
  @override
  Size get preferredSize => Size.fromHeight(appBarHeight);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: listOfAction,
      automaticallyImplyLeading: automaticallyImplyLeading,
      backgroundColor: backgroundColor,
      title: (title != null)
          ? Text(
              title!,
              style:titleStyle ??
               TextStyle(
                color: titleColor,
                fontSize: titleFontSize,
                fontWeight: FontWeight.w700
              ),
            )
          : Container(),
      titleSpacing: onTap != null ? -1.w : null,
      centerTitle: centerTitle,
      leading: (onTap != null ) ? Center(
              child: InkWell(
                  customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  onTap: onTap,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: AppColors.primaryFontColor,
                    ),
                  )),
            ) : null,
      elevation: elevation,
    );
  }
}
