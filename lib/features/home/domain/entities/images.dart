import 'package:equatable/equatable.dart';

class Images extends Equatable {
  final String nameEntity;
  final bool isFolderEntity;
  final List<Images>? childrenEntity;

  const Images(this.nameEntity, this.isFolderEntity, this.childrenEntity);

  @override
  List<Object?> get props => [nameEntity, isFolderEntity, childrenEntity];
}
