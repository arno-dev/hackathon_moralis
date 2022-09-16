import 'package:d_box/features/home/data/models/push_notification_model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'alerts_payload_model.dart';
import '../../domain/entities/alerts.dart';

part 'alerts_model.g.dart';

@JsonSerializable()
class AlertsModel extends Alerts {
  final PushNotificationModel message;
  final AlertsPayloadModel payload;
  final DateTime createdAt;

  const AlertsModel(
      {required this.message, required this.payload, required this.createdAt})
      : super(message, payload, createdAt);
  factory AlertsModel.fromJson(Map<String, dynamic> json) =>
      _$AlertsModelFromJson(json);
  Map<String, dynamic> toJson() => _$AlertsModelToJson(this);
}
