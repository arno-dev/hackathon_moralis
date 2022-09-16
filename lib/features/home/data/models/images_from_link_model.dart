import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/images_from_link.dart';
import 'images_model.dart';

part 'images_from_link_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ImagesFromLinkModel extends ImagesFromLink {
  final String ipfsKey;
  final String origin;
  final String dest;
  final String cid;
  final DateTime? createdAt;
  final ImagesModel? filetree;
  const ImagesFromLinkModel(
    this.ipfsKey,
    this.origin,
    this.dest,
    this.cid,
    this.createdAt,
    this.filetree,
  ) : super(
          ipfsKey,
          origin,
          dest,
          cid,
          createdAt,
          filetree,
        );

  factory ImagesFromLinkModel.fromJson(Map<String, dynamic> json) =>
      _$ImagesFromLinkModelFromJson(json);
  Map<String, dynamic> toJson() => _$ImagesFromLinkModelToJson(this);
}
