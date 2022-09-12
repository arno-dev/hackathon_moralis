import 'package:flutter/material.dart';

class DAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DAppBar(
      {super.key,
      this.title,
      this.backgroundColor = Colors.transparent,
      this.appBarHeight = 65,
      this.elevation = 0,
      this.listOfAction,
      this.leading,
      this.centerTitle = true,
      this.automaticallyImplyLeading = false});
  final String? title;
  final Color backgroundColor;
  final double appBarHeight;
  final double elevation;
  final List<Widget>? listOfAction;
  final Widget? leading;
  final bool centerTitle;
  final bool automaticallyImplyLeading;

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
              style: const TextStyle(color: Colors.red),
            )
          : Container(),
      centerTitle: centerTitle,
      leading: (leading == null) ? leading : null,
      elevation: elevation,
    );
  }
}
