import 'package:flutter/material.dart';

class DboxCheckBox extends StatefulWidget {
  final String title;
  final Color checkBoxColor;
  final Function onTab;

  const DboxCheckBox(
      {super.key, required this.title, this.checkBoxColor = const Color(0xffA24FFD),required this.onTab});

  @override
  State<DboxCheckBox> createState() => _DboxCheckBoxState();
}

class _DboxCheckBoxState extends State<DboxCheckBox> {
  bool isChecked = false;

  void onChangeTab() {
    setState(() {
      isChecked = !isChecked;
    });
    widget.onTab(isChecked);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashFactory: NoSplash.splashFactory,
      onTap: onChangeTab,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(
            checkColor: isChecked ? widget.checkBoxColor : Colors.grey,
            value: isChecked,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            side: MaterialStateBorderSide.resolveWith(
              (states) => BorderSide(
                  width: 1.0,
                  color: isChecked ? widget.checkBoxColor : Colors.grey),
            ),
            fillColor: MaterialStateProperty.all(Colors.white),
            onChanged: (value) => onChangeTab(),
          ),
          Text(
            widget.title,
            style: TextStyle(
                color: isChecked ? widget.checkBoxColor  : Colors.grey),
          )
        ],
      ),
    );
  }
}
