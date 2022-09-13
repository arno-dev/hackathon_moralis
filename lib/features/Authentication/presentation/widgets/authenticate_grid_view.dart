import 'package:d_box/core/constants/colors.dart';
import 'package:flutter/material.dart';
import '../../../../core/widgets/base_button.dart';
import 'authentication_grid.dart';

class AuthenticateGridView extends StatefulWidget {
  const AuthenticateGridView({super.key});

  @override
  State<AuthenticateGridView> createState() => _AuthenticateGridViewState();
}

class _AuthenticateGridViewState extends State<AuthenticateGridView> {
  List<String> initialData = [
    'banana',
    'cocotaco',
    'apple',
    'mango',
    'mapao',
    'berry',
  ];
  List<String> dataList = List<String>.filled(6, '');

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AuthenticationGrid(
          gridColor: Colors.grey,
          data: dataList,
          currentIndex: dataList.where((value) => value != '').toList().length,
          getIndex: (index) {
            var store = [...dataList];
            store.removeAt(index);
            store.add('');
            dataList = [...store];
            setState(() {});
          },
        ),
        SizedBox(
          height: 10,
        ),
        Wrap(
          children: List.generate(
              initialData.length,
              (index) => Container(
                    margin: const EdgeInsets.all(3),
                    child: BaseButton(
                      isDisabled: dataList.contains(initialData[index]),
                      borderColor: AppColors.primaryColor,
                      text: initialData[index],
                      onTap: () {
                        // Check is value in dataList exists?
                        // if (dataList.contains(initialData[index])) {
                        //   return;
                        // }
                        // get current index
                        int currentIndex = dataList
                            .where((value) => value != '')
                            .toList()
                            .length;

                        if (currentIndex < dataList.length) {
                          setState(() {
                            dataList[currentIndex] = initialData[index];
                          });
                        }
                      },
                    ),
                  )),
        ),
        BaseButton(
          text: "Clear",
          onTap: () {
            setState(() {
              dataList = List<String>.filled(6, '');
              // get current index
            });
          },
        )
      ],
    );
  }
}
