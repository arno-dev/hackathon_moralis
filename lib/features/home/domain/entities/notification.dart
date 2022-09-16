

import 'package:equatable/equatable.dart';

class Notification extends Equatable{
    final String titleEnitity;
  final String bodyEnitity;

  const Notification(this.titleEnitity, this.bodyEnitity);
  
  @override
  List<Object?> get props => [titleEnitity, bodyEnitity];
}