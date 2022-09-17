import '../../../../core/config/themes/app_text_theme.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../../generated/assets.gen.dart';
import '../../domain/entities/images.dart';
import '../../domain/entities/images_from_link.dart';
import '../widgets/child_folder_view.dart';
import '../widgets/emtry_file.dart';

class DetailView extends StatelessWidget {
  const DetailView({
    Key? key,
    required this.stackName,
    required this.stack,
    required this.imagesFromLink,
    required this.currentFolder,
    required this.recents,
    required this.onBackFolder,
    required this.onOpenFolder,
    required this.onPreview,
  }) : super(key: key);

  final String stackName;
  final List<int> stack;
  final ImagesFromLink? imagesFromLink;
  final List<Images> currentFolder;
  final List<ImagesFromLink> recents;
  final void Function() onBackFolder;
  final void Function(int, int) onOpenFolder;
  final void Function(int, int) onPreview;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          if (stackName != "")
            InkWell(
              onTap: (stack.length >= 2) ? onBackFolder : null,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (stack.length >= 2)
                    Assets.icons.backward.svg(
                      color: AppColors.disAbleColor,
                      width: 10.0,
                      height: 10.0,
                    ),
                  const SizedBox(width: 5),
                  Text(stackName,
                      style: Theme.of(context).textTheme.customText7),
                ],
              ),
            ),
          const SizedBox(
            height: 10,
          ),
          imagesFromLink != null
              ? ChildFolderView(
                  onTap: (int index, int rootIndex) async {
                    if (currentFolder[index].isFolderEntity) {
                      onOpenFolder(rootIndex, index);
                    } else {
                      onPreview(rootIndex, index);
                    }
                  },
                  folders: currentFolder,
                  modified: recents[0].createdAtEntity,
                  rootIndex: 0)
              : const EmtryFileWidget(),
        ],
      ),
    );
  }
}
