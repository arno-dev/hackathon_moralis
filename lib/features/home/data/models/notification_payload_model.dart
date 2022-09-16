import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/notification_payload.dart';

part 'notification_payload_model.g.dart';

@JsonSerializable()
class NotificationPayloadModel extends NotificationPayload {
  final String link;

  const NotificationPayloadModel(
      {required this.link})
      : super(link);
  factory NotificationPayloadModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationPayloadModelFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationPayloadModelToJson(this);
}