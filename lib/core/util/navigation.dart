import 'package:flutter/material.dart';

class Navigation {
  static Future bottomSheetModel(BuildContext context, Widget children) {
    return showModalBottomSheet(
      context: context,
      builder: (_) {
        return children;
      },
    );
  }

  static Future dBoxShowDialog(BuildContext context, Widget child) async {
    return await showDialog<void>(
        context: context,
        builder: (_) {
          return child;
        });
  }
}
