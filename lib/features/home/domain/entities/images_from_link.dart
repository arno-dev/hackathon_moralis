import 'package:equatable/equatable.dart';

import 'images.dart';

class ImagesFromLink extends Equatable {
  final String ipfsKeyEntity;
  final String originEntity;
  final String destEntity;
  final String cidEntity;
  final DateTime createdAtEntity;
  final Images? filetreeEntity;

  const ImagesFromLink(
    this.ipfsKeyEntity,
    this.originEntity,
    this.destEntity,
    this.cidEntity,
    this.createdAtEntity,
    this.filetreeEntity,
  );

  @override
  List<Object?> get props => [cidEntity, filetreeEntity, ipfsKeyEntity];
}
