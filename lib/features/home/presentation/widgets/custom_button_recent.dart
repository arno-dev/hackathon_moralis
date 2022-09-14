import 'package:flutter/material.dart';

import '../../../../generated/assets.gen.dart';

class CustomButtonRecent extends StatelessWidget {
  final Function onPressed;
  const CustomButtonRecent({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Recent ",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 5),
          Assets.icons.down.svg(
            width: 6.0,
            height: 6.0,
          ),
        ],
      ),
    );
  }
}
