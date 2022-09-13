import 'package:equatable/equatable.dart';

class Images extends Equatable {
  final String name;
  final bool isFolder;
  final List<Images>? children;

  const Images(this.name, this.isFolder, this.children);

  @override
  List<Object?> get props => [name, isFolder, children];
}
