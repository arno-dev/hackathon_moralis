import 'package:d_box/core/constants/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../generated/assets.gen.dart';
import '../../domain/entities/images.dart';

class ChildFolderView extends StatelessWidget {
  const ChildFolderView({
    Key? key,
    required this.folders,
     this.modified,
    required this.rootIndex,
    required this.onTap

  }) : super(key: key);

  final List<Images>? folders;
  final DateTime? modified;
  final int rootIndex;
  final void Function(int, int) onTap;

  @override
  Widget build(BuildContext context) {
    List<Images>? children = folders ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...List.generate(
          children.length,
          (index) => GestureDetector(
            onTap: () {
              onTap(index, rootIndex);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                index == 0 ? const SizedBox.shrink() : const Divider(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    children[index].isFolderEntity
                        ? Assets.images.folder.image(
                            scale: .2,
                            width: 50,
                            height: 50,
                          )
                        : const Icon(
                            Icons.image,
                            size: 50,
                            color: AppColors.primaryPurpleColor,
                          ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 70.w,
                          child: Text(
                            children[index].nameEntity,
                            style: const TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        if(modified != null) ...[Text(
                          'Modified ${DateFormat('dd MMM yyyy').format(modified!)}',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.grey.withOpacity(.5),
                          ),
                        ),]
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
