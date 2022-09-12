import 'package:flutter/material.dart';

class DboxUnorderedList extends StatelessWidget {
  final List<String> texts;
  final double lineHeight;
  final double fontSize;
  const DboxUnorderedList(this.texts, {super.key, this.lineHeight = 1.4,this.fontSize = 16});

  @override
  Widget build(BuildContext context) {
    var widgetList = <Widget>[];
    for (var text in texts) {
      // Add list item
      widgetList.add(DboxUnorderedListItem(text,lineHeight: lineHeight,fontSize:fontSize));
      // Add space between items
      widgetList.add(const SizedBox(height: 5.0));
    }

    return Column(children: widgetList);
  }
}

class DboxUnorderedListItem extends StatelessWidget {


  const DboxUnorderedListItem(this.text, {super.key, required this.lineHeight,required this.fontSize});
  final String text;
  final double lineHeight;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("• ", style: TextStyle(height: lineHeight, fontSize: fontSize)),
        Expanded(
          child: Text(
            text,
            style:  TextStyle(
                height: lineHeight, fontSize: fontSize, fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );
  }
}
