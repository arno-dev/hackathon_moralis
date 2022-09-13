import 'package:equatable/equatable.dart';

import 'images.dart';

class ImagesFromLink extends Equatable {
  final String ipfsKey;
  final String cid;
  final Images? filetree;

  const ImagesFromLink(this.cid, this.filetree, this.ipfsKey);

  @override
  List<Object?> get props => [cid, filetree];
}
