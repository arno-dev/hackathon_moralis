import 'package:d_box/core/constants/colors.dart';
import 'package:d_box/features/Authentication/presentation/cubit/authentication_cubit_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/widgets/base_button.dart';
import 'authentication_grid.dart';

class AuthenticateGridView extends StatelessWidget {
  const AuthenticateGridView(
      {super.key,
      required this.dataList,
      required this.onRemove,
      required this.onAdd,
      this.isValidated = false});
  final List<String> dataList;
  final void Function(int) onRemove;
  final void Function(int) onAdd;
  final bool isValidated;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AuthenticationGrid(
            gridColor: isValidated
                ? AppColors.accentColor
                : dataList.contains("")
                    ? AppColors.baseBorderColor
                    : AppColors.primaryPurpleColor,
            data: dataList,
            textColor: dataList.contains("")
                ? AppColors.grey
                : AppColors.primaryPurpleColor,
            borderColor: AppColors.baseBorderColor,
            currentIndex:
                dataList.where((value) => value != '').toList().length,
            getIndex: onRemove),
        const SizedBox(
          height: 20,
        ),
        BlocSelector<AuthenticationCubit, AuthenticationState, List>(
          selector: (state) {
            return state.newMnemonic ?? [];
          },
          builder: (context, newMnemonic) {
            List<String> newRandomMnonic =
                context.read<AuthenticationCubit>().randomData;
            return SizedBox(
              height: 35.w,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 1.w,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    crossAxisCount: 3),
                itemBuilder: (_, index) => BaseButton(
                  textColor: AppColors.grey,
                  isDisabled: newMnemonic.contains(newRandomMnonic[index]),
                  borderColor: AppColors.disAbleColor,
                  text: newRandomMnonic[index],
                  onTap: newMnemonic[index].contains(newRandomMnonic[index])
                      ? null
                      : () => onAdd(index),
                ),
                itemCount: newMnemonic.length,
              ),
            );
          },
        ),
      ],
    );
  }
}
