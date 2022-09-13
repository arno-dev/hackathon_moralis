import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/images.dart';
part 'images_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ImagesModel extends Images {
  final String name;
  final bool isFolder;
  final List<ImagesModel>? children;

  const ImagesModel({required this.name, required this.isFolder, this.children})
      : super(
          name,
          isFolder,
          children,
        );
  factory ImagesModel.fromJson(Map<String, dynamic> json) =>
      _$ImagesModelFromJson(json);
  Map<String, dynamic> toJson() => _$ImagesModelToJson(this);
}
