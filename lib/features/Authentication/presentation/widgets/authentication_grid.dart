import 'package:d_box/core/constants/colors.dart';
import 'package:flutter/material.dart';

import 'gird_button.dart';

class AuthenticationGrid extends StatelessWidget {
  const AuthenticationGrid(
      {super.key,
      this.isDisplay = false,
      this.borderColor = Colors.grey,
      required this.gridColor,
      required this.data,
      this.getIndex,
      required this.currentIndex});
  final bool isDisplay;
  final Color borderColor;
  final Color gridColor;
  final List<String> data;
  final int currentIndex;
  final void Function(int)? getIndex;

  @override
  Widget build(BuildContext context) {
    int rightLength = ((data.length) / 2).round();
    int leftLength = (data.length) ~/ 2;
    return Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 34),
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: gridColor),
            borderRadius: BorderRadius.circular(14)),
        child: !isDisplay
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                      children: List.generate(
                          rightLength,
                          (index) => Column(
                                children: [
                                  const SizedBox(height: 16),
                                  GridButton(
                                    onTap: (_) {
                                      getIndex!(index);
                                    },
                                    index: index + 1,
                                    borderColor: currentIndex == index ||
                                            data[index].isNotEmpty
                                        ? AppColors.backgroundColor
                                        : borderColor,
                                    isDottedButton: data[index].isEmpty,
                                    text: data[index],
                                  ),
                                ],
                              ))),
                  Column(
                      children: List.generate(
                          leftLength,
                          (index) => Column(
                                children: [
                                  const SizedBox(height: 16),
                                  GridButton(
                                    onTap: (_) {
                                      getIndex!(index + rightLength);
                                    },
                                    index: index + 1 + rightLength,
                                    borderColor: currentIndex ==
                                                index + rightLength ||
                                            data[index + rightLength].isNotEmpty
                                        ? AppColors.backgroundColor
                                        : borderColor,
                                    isDottedButton:
                                        data[index + rightLength].isEmpty,
                                    text: data[index + rightLength],
                                  ),
                                ],
                              ))),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                      children: List.generate(
                          rightLength,
                          (index) => Column(
                                children: [
                                  const SizedBox(height: 16),
                                  GridButton(
                                    borderColor: borderColor,
                                    isDottedButton: data[index].isEmpty,
                                    text: data[index],
                                  ),
                                ],
                              ))),
                  Column(
                      children: List.generate(
                          leftLength,
                          (index) => Column(
                                children: [
                                  const SizedBox(height: 16),
                                  GridButton(
                                    borderColor: borderColor,
                                    isDottedButton:
                                        data[index + rightLength].isEmpty,
                                    text: data[index + rightLength],
                                  ),
                                ],
                              ))),
                ],
              ));
  }
}
