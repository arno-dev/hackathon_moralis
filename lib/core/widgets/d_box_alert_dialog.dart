import 'package:flutter/material.dart';

class DboxAlertDialog extends StatelessWidget {
  final String title;
  final String? textContent;
  final Color titleColor;
  final double borderRadius;
  final List<Widget> content;
  final double contentPadding;
  final double actionsPadding;
  final List<Widget>? actions;

  const DboxAlertDialog(
      {super.key,
      required this.title,
      this.textContent,
      required this.content,
      this.titleColor = Colors.black,
      this.borderRadius = 16.0,
      this.contentPadding = 16.0,
      this.actionsPadding = 12.0,
      this.actions});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsPadding: EdgeInsets.all(actionsPadding),
      contentPadding: EdgeInsets.all(contentPadding),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius)),
      title: Center(
          child: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w700, color: titleColor),
      )),
      content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            (textContent != null) ? Text(textContent!) : Container(),
            ...content
          ]),
      actions: actions ?? [],
    );
  }
}
