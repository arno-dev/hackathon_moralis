import 'package:equatable/equatable.dart';

class AlertsPayload extends Equatable {
  final String originEntity;
  final String ipfsKeyEntity;
  final String? cidEntity;
  final String? linkEntity;
  final String? createdAtEntity;

  const AlertsPayload(this.originEntity, this.ipfsKeyEntity,this.cidEntity,this.linkEntity,this.createdAtEntity);

  @override
  List<Object?> get props => [originEntity,ipfsKeyEntity,cidEntity,linkEntity,createdAtEntity];
}
