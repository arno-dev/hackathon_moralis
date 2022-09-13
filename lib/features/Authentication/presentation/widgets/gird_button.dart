import 'package:flutter/material.dart';

import '../../../../core/widgets/base_button.dart';
import '../../../../core/widgets/dotted_button.dart';

class GridButton extends StatelessWidget {
  const GridButton(
      {super.key, this.text,  this.index, this.isDottedButton = true, required this.borderColor, this.onTap});
  final String? text;
  final int? index;
  final bool isDottedButton;
  final Color borderColor; 
  final void Function(int)? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
       (index != null)? SizedBox(
          width: 22,
          child: Text("$index.",textAlign: TextAlign.end),
        ) : Container(),
        const SizedBox(width: 5,),
        isDottedButton
            ?  DottedButton(
                borderColor:borderColor,
                onTap: (){
                  if  ( onTap!=null && index != null)  {
                    onTap!(index!);
                  }
                } 
              )
            : BaseButton(
                text: text,
                borderColor: borderColor,
                onTap: (){
                  if  ( onTap!=null && index != null)  {
                    onTap!(index!);
                  }
                } ,
              ),
      ],
    );
  }
}
