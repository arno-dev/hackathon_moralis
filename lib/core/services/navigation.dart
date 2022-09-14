import 'package:flutter/material.dart';
import 'package:no_context_navigation/no_context_navigation.dart';

class Navigation {
  static Future bottomSheetModel(BuildContext context, List<Widget> children) {
    return showModalBottomSheet(
      context: context,
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: children,
        );
      },
    );
  }
}
