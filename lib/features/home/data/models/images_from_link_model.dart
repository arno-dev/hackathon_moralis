import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/images_from_link.dart';
import 'images_model.dart';

part 'images_from_link_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ImagesFromLinkModel extends ImagesFromLink {
  // final String ipfsKey;
  // final String cid;
  final ImagesModel? filetree;
  const ImagesFromLinkModel(
      {required String cid, required String ipfsKey, this.filetree})
      : super(
          cid,
          filetree,
          ipfsKey,
        );

  factory ImagesFromLinkModel.fromJson(Map<String, dynamic> json) =>
      _$ImagesFromLinkModelFromJson(json);
  Map<String, dynamic> toJson() => _$ImagesFromLinkModelToJson(this);
}
