import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/notification.dart';
part 'notifcation_model.g.dart';



@JsonSerializable()
class NotificationModel extends Notification {
  final String title;
  final String body;

  const NotificationModel(
      {required this.title, required this.body})
      : super(title, body);
  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);
}

