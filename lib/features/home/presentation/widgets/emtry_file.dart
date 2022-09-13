import 'package:flutter/material.dart';

import '../../../../generated/assets.gen.dart';

class EmtryFileWidget extends StatelessWidget {
  const EmtryFileWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Assets.icons.recent.svg(),
        const SizedBox(height: 40),
        const Center(
          child: SizedBox(
            width: 250,
            child: Text(
              "Easy to send files to family, friends, and co-workers",
              textAlign: TextAlign.center,
              overflow: TextOverflow.clip,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 15,
                height: 1.8,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        const Center(
          child: Text(
            "After you send a file, it'll show up here.",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        )
      ],
    );
  }
}
