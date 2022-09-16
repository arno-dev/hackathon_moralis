
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Image.asset('assets/gifs/loading.gif',
                    gaplessPlayback: true, height: 50));
  }
}