import 'package:d_box/core/config/themes/app_text_theme.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../generated/assets.gen.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../domain/entities/alerts.dart';

class NotificationListView extends StatelessWidget {
  const NotificationListView({
    Key? key,
    required this.alerts,
  }) : super(key: key);

  final List<Alerts>? alerts;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...List.generate(
          alerts!.length,
          (index) => GestureDetector(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                index == 0 ? const SizedBox.shrink() : const Divider(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Assets.images.folder.image(
                      scale: .2,
                      width: 50,
                      height: 50,
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
                            alerts![index].messageEntity.notificationEntity.bodyEnitity,
                            maxLines: 2,
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                            timeago.format(alerts![index].createdAtEntity,
                                locale: 'en_short'),
                            style: Theme.of(context).textTheme.customText6),
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
