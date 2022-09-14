import 'image_param.dart';

class UploadImageParam {
  final List<ImageParam>? images;
  final String? origin;
  final String? dest;
  final String? encryptIpfsKey;

  const UploadImageParam({
    this.images,
    this.origin,
    this.dest,
    this.encryptIpfsKey,
  });

  factory UploadImageParam.fromMap(Map<String, dynamic> data) {
    return UploadImageParam(
      images: (data['images'] as List<dynamic>?)
          ?.map((e) => ImageParam.fromMap(e as Map<String, dynamic>))
          .toList(),
      origin: data['origin'] as String?,
      dest: data['dest'] as String?,
      encryptIpfsKey: data['encryptIpfsKey'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'images': images?.map((e) => e.toMap()).toList(),
        'origin': origin,
        'dest': dest,
        'encryptIpfsKey': encryptIpfsKey,
      };

  UploadImageParam copyWith({
    List<ImageParam>? images,
    String? origin,
    String? dest,
    String? encryptIpfsKey,
  }) {
    return UploadImageParam(
      images: images ?? this.images,
      origin: origin ?? this.origin,
      dest: dest ?? this.dest,
      encryptIpfsKey: encryptIpfsKey ?? this.encryptIpfsKey,
    );
  }
}
