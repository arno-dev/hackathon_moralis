import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';

class DboxSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const DboxSwitch({Key? key, required this.value, required this.onChanged})
      : super(key: key);

  @override
  State<DboxSwitch> createState() => _DboxSwitchState();
}

class _DboxSwitchState extends State<DboxSwitch>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 60));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController!,
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            if (_animationController!.isCompleted) {
              _animationController!.reverse();
            } else {
              _animationController!.forward();
            }
            widget.value == false
                ? widget.onChanged(true)
                : widget.onChanged(false);
          },
          child: Container(
            width: 45.0,
            height: 28.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.0),
                border:
                    Border.all(width: 2, color: AppColors.primaryPurpleColor)),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 2.0, bottom: 2.0, right: 2.0, left: 2.0),
              child: Container(
                alignment:
                    widget.value ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: 15.0,
                  height: 15.0,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryPurpleColor),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
