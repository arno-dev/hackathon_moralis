import 'package:flutter/material.dart';

class DboxButtonBottomSheet extends StatelessWidget {
  final String label;
  final Function onTap;

  const DboxButtonBottomSheet({
    Key? key,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.only(left: 20),
        alignment: Alignment.centerLeft,
        height: 45,
        width: double.infinity,
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
