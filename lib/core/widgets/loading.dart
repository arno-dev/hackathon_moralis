import 'package:flutter/material.dart';

import '../../generated/assets.gen.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Image.asset(Assets.gifs.loading.path,
            gaplessPlayback: true, height: 50));
  }
}
