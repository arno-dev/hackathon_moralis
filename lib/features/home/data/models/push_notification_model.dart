import 'package:d_box/features/home/data/models/notifcation_model.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/push_notification.dart';
import 'notification_payload_model.dart';

part 'push_notification_model.g.dart';


@JsonSerializable()
class PushNotificationModel extends PushNotification {
  final NotificationModel notification;
  final NotificationPayloadModel? payload;

  const PushNotificationModel(
      {required this.notification, required this.payload})
      : super(notification, payload);
  factory PushNotificationModel.fromJson(Map<String, dynamic> json) =>
      _$PushNotificationModelFromJson(json);
  Map<String, dynamic> toJson() => _$PushNotificationModelToJson(this);
}
