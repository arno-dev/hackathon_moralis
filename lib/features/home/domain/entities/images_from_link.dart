import 'package:equatable/equatable.dart';

import 'images.dart';

class ImagesFromLink extends Equatable {
  final String ipfsKeyEntity;
  final String cidEntity;
  final Images? filetreeEntity;

  const ImagesFromLink(this.cidEntity, this.filetreeEntity, this.ipfsKeyEntity);

  @override
  List<Object?> get props => [cidEntity, filetreeEntity, ipfsKeyEntity];
}
