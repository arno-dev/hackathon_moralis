import 'package:flutter/cupertino.dart';
import 'stepper.dart';

class DCustomStepper extends StatefulWidget {
  const DCustomStepper({super.key, this.lineColor, this.stepSize,required this.listOfContent, required this.listOfContentText, required this.textWidth, required this.stepperhorizontal, this.physics});
  final Color? lineColor;
  final double? stepSize;
  final List<Widget> listOfContent;
  final List<String> listOfContentText;
  final double textWidth;
  final double stepperhorizontal;
  final ScrollPhysics? physics;


  @override
  State<DCustomStepper> createState() => _DCustomStepperState();
}

class _DCustomStepperState extends State<DCustomStepper> {
    int _index = 0;
  @override
  Widget build(BuildContext context) {
    return Stepper(
      physics: widget.physics,
      lineColor: widget.lineColor,
      type: StepperType.horizontal,
      currentStep: _index,
      stepperhorizontal: widget.stepperhorizontal,
      stepSize: widget.stepSize,
      elevation: 0,
      onStepTapped: (int index) {
        setState(() {
          _index = index;
        });
      },
      controlsBuilder: (BuildContext context, ControlsDetails details) {
        return Container();
      },
      steps: [
        Step(
          isActive: (_index == 0),
                   label: SizedBox(
            width: widget.textWidth,
            child: Text(widget.listOfContentText[0],textAlign: TextAlign.center,)),
          content:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [ widget.listOfContent[1]
            ],
          ),
        ),
        Step(
          label: SizedBox(
            width: widget.textWidth,
            child: Text(widget.listOfContentText[1],textAlign: TextAlign.center,)),
          isActive: (_index == 1),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              widget.listOfContent[1]
            ],
          ),
        ),
      ],
    );
  }
}