import 'dart:convert';

class ImageParam {
  final String? path;
  final String? content;

  const ImageParam({this.path, this.content});

  factory ImageParam.fromMap(Map<String, dynamic> data) => ImageParam(
        path: data['path'] as String?,
        content: data['content'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'path': path,
        'content': content,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Image].
  factory ImageParam.fromJson(String data) {
    return ImageParam.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Image] to a JSON string.
  String toJson() => json.encode(toMap());

  ImageParam copyWith({
    String? path,
    String? content,
  }) {
    return ImageParam(
      path: path ?? this.path,
      content: content ?? this.content,
    );
  }
}
