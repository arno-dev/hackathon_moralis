import 'package:equatable/equatable.dart';

class Geo extends Equatable {
  final String latEntity, lngEntity;

  const Geo(this.latEntity, this.lngEntity);

  @override
  List<Object?> get props => [latEntity, lngEntity];
}
