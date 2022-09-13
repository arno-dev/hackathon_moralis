import 'package:flutter/material.dart';

class DAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DAppBar({
    super.key,
    this.title,
    this.backgroundColor = Colors.transparent,
    this.appBarHeight = 65,
    this.elevation = 0,
    this.listOfAction,
    this.leading,
    this.centerTitle = true,
    this.automaticallyImplyLeading = false,
    this.titleColor = Colors.red,
    this.titleFontSize = 18.0,
  });
  final String? title;
  final Color backgroundColor;
  final double appBarHeight;
  final double elevation;
  final List<Widget>? listOfAction;
  final Widget? leading;
  final bool centerTitle;
  final bool automaticallyImplyLeading;
  final Color titleColor;
  final double titleFontSize;
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
              style: TextStyle(
                color: titleColor,
                fontSize: titleFontSize,
              ),
            )
          : Container(),
      centerTitle: centerTitle,
      leading: (leading == null) ? leading : null,
      elevation: elevation,
    );
  }
}
