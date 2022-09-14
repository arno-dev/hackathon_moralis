import 'package:flutter/material.dart';

import '../../domain/entities/images.dart';
import '../../domain/entities/images_from_link.dart';
import 'child_folder_view.dart';

class RootFolderView extends StatelessWidget {
  const RootFolderView({
    Key? key,
    required this.recents,
  }) : super(key: key);

  final List<ImagesFromLink>? recents;

  @override
  Widget build(BuildContext context) {
    List<ImagesFromLink>? listRecent = recents ?? [];
    return Expanded(
      child: ListView.builder(
        itemCount: listRecent.length,
        itemBuilder: (BuildContext context, int index) {
          DateTime modified = listRecent[index].createdAtEntity;
          List<Images>? folders =
              listRecent[index].filetreeEntity?.childrenEntity ?? [];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              index == 0 ? const SizedBox.shrink() : const Divider(),
              ChildFolderView(
                folders: folders,
                modified: modified,
                rootIndex: index,
              ),
            ],
          );
        },
      ),
    );
  }
}
