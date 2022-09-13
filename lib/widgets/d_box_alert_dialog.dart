import 'package:flutter/material.dart';

class DboxAlertDialog extends StatelessWidget {
  final String title;
  final String? textContent;
  final Color titleColor;
  final double borderRadius;
  final List<Widget> content;

  const DboxAlertDialog({
    super.key,
    required this.title,
    this.textContent,
    required this.content,
    this.titleColor = Colors.black,
    this.borderRadius = 16.0
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape:  RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius))),
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
    );
  }
}
