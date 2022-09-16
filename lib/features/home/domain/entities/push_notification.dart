
import 'package:d_box/features/home/domain/entities/notification.dart';
import 'package:d_box/features/home/domain/entities/notification_payload.dart';
import 'package:equatable/equatable.dart';

class PushNotification extends Equatable {
  final Notification notificationEntity;
  final NotificationPayload? payloadEntity;

  const PushNotification(this.notificationEntity, this.payloadEntity);
  
  @override
  List<Object?> get props => [notificationEntity, payloadEntity];
}