import 'package:equatable/equatable.dart';

class SaveImages extends Equatable {
  final String originEntity;
  final String destEntity;
  final String ipfsKeyEntity;
  final String cidEntity;
  final String linkEntity;
  final String createdAtEntity;

  const SaveImages(
    this.originEntity,
    this.destEntity,
    this.ipfsKeyEntity,
    this.cidEntity,
    this.linkEntity,
    this.createdAtEntity,
  );

  @override
  List<Object?> get props => [
        originEntity,
        destEntity,
        ipfsKeyEntity,
        cidEntity,
        linkEntity,
        createdAtEntity
      ];
}
