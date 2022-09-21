import 'package:d_box/features/home/presentation/widgets/root_folder.view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/widgets/d_box_textfield.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../domain/entities/images.dart';
import '../../domain/entities/images_from_link.dart';
import 'child_folder_view.dart';
import 'custom_button_recent.dart';
import 'emtry_file.dart';

class MainView extends StatelessWidget {
  const MainView({
    Key? key,
    required this.stack,
    required this.name,
    required this.recents,
    required this.currentFolder,
    required this.searchController,
    required this.onBackFolder,
    required this.onOpenFolder,
    required this.onPreview,
  }) : super(key: key);

  final List<int> stack;
  final String name;
  final List<ImagesFromLink> recents;
  final List<Images> currentFolder;
  final TextEditingController searchController;
  final void Function() onBackFolder;
  final void Function(int, int) onOpenFolder;
  final void Function(int, int) onPreview;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DboxTextField(
            hintText: LocaleKeys.searchYourFiles.tr(),
            isSearch: true,
            controller: searchController,
          ),
          stack.isNotEmpty
              ? TextButton(
                  onPressed: onBackFolder,
                  child: Row(
                    children: [
                      Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: AppColors.primaryColor,
                        size: 14.sp,
                      ),
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ))
              : CustomButtonRecent(
                  onPressed: () {},
                ),
          recents.isNotEmpty
              ? stack.isEmpty
                  ? RootFolderView(
                      recents: recents,
                      onTap: (index, rootIndex) async {
                        if (recents[rootIndex]
                                .filetreeEntity
                                ?.childrenEntity?[index]
                                .isFolderEntity ==
                            true) {
                          onOpenFolder(rootIndex, index);
                        } else {
                          onPreview(rootIndex, index);
                        }
                      },
                    )
                  : ChildFolderView(
                      onTap: (int index, int rootIndex) async {
                        if (currentFolder[index].isFolderEntity) {
                          onOpenFolder(rootIndex, index);
                        } else {
                          onPreview(rootIndex, index);
                        }
                      },
                      folders: currentFolder,
                      modified: recents[stack[0]].createdAtEntity,
                      rootIndex: stack[0])
              : const Expanded(
                  child: EmtryFileWidget(),
                ),
        ],
      ),
    );
  }
}
