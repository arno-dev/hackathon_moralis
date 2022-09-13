import 'package:flutter/material.dart';

class DboxTextField extends StatelessWidget {
  final String hintText;
  final bool isPassword;
  final bool isSearch;
  final Color color;
  final double fontSize;
  final double borderRadius;
  final double height;
  final TextEditingController controller;

  const DboxTextField({
    super.key,
    required this.hintText,
    this.isPassword = false,
    this.isSearch = false,
    this.color = const Color(0xffeff1fe),
    this.fontSize = 16.0,
    this.borderRadius = 30,
    this.height = 50,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height,
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius), color: color),
        child: TextField(
          obscureText: isPassword,
          controller: controller,
          style: TextStyle(fontSize: fontSize),
          decoration: InputDecoration(
            prefixIcon: isSearch
                ? const Icon(
                    Icons.search,
                    color: Colors.grey,
                  )
                : null,
            hintText: hintText,
            border: InputBorder.none,
            contentPadding:
                !isSearch ? const EdgeInsets.only(left: 15, right: 15) : null,
            hintStyle: TextStyle(fontSize: fontSize, color: Colors.grey),
          ),
        ));
  }
}
