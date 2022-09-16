import 'package:d_box/features/home/domain/entities/push_notification.dart';
import 'package:equatable/equatable.dart';
import 'alerts_payload.dart';

class Alerts extends Equatable {
  final PushNotification messageEntity;
  final AlertsPayload payloadEntity;
  final DateTime createdAtEntity;

  const Alerts(this.messageEntity, this.payloadEntity, this.createdAtEntity);

  @override
  List<Object?> get props => [messageEntity,payloadEntity,createdAtEntity];
}
