import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/widgets/base_button.dart';
import '../../../../generated/locale_keys.g.dart';
import 'stepper.dart';

class DCustomStepper extends StatelessWidget {
  const DCustomStepper(
      {super.key,
      this.currentIndex = 0,
      this.onTap,
      this.lineColor,
      this.stepSize,
      required this.listOfContent,
      required this.listOfContentText,
      required this.textWidth,
      required this.stepperhorizontal,
      this.physics,
      this.textColor = AppColors.primaryPurpleColor,
      this.isValidated =true
      });
  final bool isValidated;
  final Color? lineColor;
  final double? stepSize;
  final List<Widget> listOfContent;
  final List<String> listOfContentText;
  final double textWidth;
  final double stepperhorizontal;
  final ScrollPhysics? physics;
  final void Function(int)? onTap;
  final Color textColor;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Stepper(
            physics: physics,
            lineColor: lineColor,
            type: StepperType.horizontal,
            currentStep: currentIndex,
            stepperhorizontal: stepperhorizontal,
            stepSize: stepSize,
            elevation: 0,
            controlsBuilder: (BuildContext context, ControlsDetails details) {
              return Container();
            },
            steps: [
              Step(
                isActive: (currentIndex == 0),
                label: SizedBox(
                    width: textWidth,
                    child: Text(
                      listOfContentText[0],
                      textAlign: TextAlign.center,style: TextStyle(color: textColor),
                    )),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [listOfContent[0]],
                ),
              ),
              Step(
                label: SizedBox(
                    width: textWidth,
                    child: Text(
                      listOfContentText[1],
                      textAlign: TextAlign.center,
                      style: TextStyle(color: textColor)
                    )),
                isActive: (currentIndex == 1),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [listOfContent[1]],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB( 23,20,23,30),
          child: BaseButton(
            isDisabled: isValidated,
            onTap: !isValidated? () {
              if  (onTap != null) onTap!(currentIndex);
            } : null,
            text: LocaleKeys.continueText.tr(),
            backgroundColor: AppColors.primaryPurpleColor,
            buttonWidth: 100.w,
            buttonHeight: 47,
            textColor: AppColors.secondaryFontColor,
          ),
        ),
      ],
    );
  }
}
