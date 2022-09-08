import 'package:equatable/equatable.dart';

class Company extends Equatable {
  final String nameEntity, catchPhraseEntity, bsEntity;

  const Company(this.nameEntity, this.catchPhraseEntity, this.bsEntity);

  @override
  List<Object?> get props => [
        nameEntity,
        catchPhraseEntity,
        bsEntity,
      ];
}
