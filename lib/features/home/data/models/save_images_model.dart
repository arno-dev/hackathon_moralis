import 'package:d_box/features/home/domain/entities/save_images.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part "save_images_model.g.dart";

@JsonSerializable()
class SaveImagesModel extends SaveImages {
  final String origin;
  final String dest;
  final String ipfsKey;
  final String cid;
  final String link;
  final String createdAt;
  const SaveImagesModel({
    required this.origin,
    required this.dest,
    required this.ipfsKey,
    required this.cid,
    required this.link,
    required this.createdAt,
  }) : super(
          origin,
          dest,
          ipfsKey,
          cid,
          link,
          createdAt,
        );
  factory SaveImagesModel.fromJson(Map<String, dynamic> json) =>
      _$SaveImagesModelFromJson(json);
  Map<String, dynamic> toJson() => _$SaveImagesModelToJson(this);
}
