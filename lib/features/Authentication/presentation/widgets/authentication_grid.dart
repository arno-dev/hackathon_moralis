import 'package:flutter/material.dart';

import 'gird_button.dart';

class AuthenticationGrid extends StatelessWidget {
  const AuthenticationGrid(
      {super.key,
      this.isDisplay = false,
      required this.borderColor,
      required this.gridColor,
      required this.data});
  final bool isDisplay;
  final Color borderColor;
  final Color gridColor;
  final List<String> data;
  @override
  Widget build(BuildContext context) {
    int rightLength =  ((data.length)/2).round();
    int leftLength = (data.length)~/2;
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
                                    index: index + 1,
                                    borderColor: borderColor,
                                    isDottedButton: data[index].isEmpty,
                                    text: data[index]
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
                                      index: index+1+ rightLength,
                                      borderColor: borderColor,
                                      isDottedButton: data[index + rightLength].isEmpty,text: data[index + rightLength],),
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
                                    isDottedButton: data[index].isEmpty,text: data[index],
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
                                      isDottedButton: data[index + rightLength].isEmpty,text: data[index + rightLength],),
                                ],
                              ))),
                ],
              ));
  }
}
