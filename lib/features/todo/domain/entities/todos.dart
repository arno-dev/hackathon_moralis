import 'package:equatable/equatable.dart';

class Todos extends Equatable {
  final int userIdEntity, idEntity;
  final String titleEntity;
  final bool completedEntity;

  const Todos(
      this.userIdEntity, this.idEntity, this.titleEntity, this.completedEntity);

  @override
  List<Object?> get props => [
        userIdEntity,
        idEntity,
        titleEntity,
        completedEntity,
      ];
}
