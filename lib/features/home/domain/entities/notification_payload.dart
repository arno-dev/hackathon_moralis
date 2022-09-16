

import 'package:equatable/equatable.dart';

class NotificationPayload extends Equatable {
  final String linkEntity;

  const NotificationPayload(this.linkEntity);
  @override
  List<Object?> get props =>  [linkEntity];
}
