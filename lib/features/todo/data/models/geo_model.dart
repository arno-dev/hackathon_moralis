
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/geo.dart';
part 'geo_model.g.dart';

@JsonSerializable()
class GeoModel extends Geo {
  final String lng;
  final String lat;

  const GeoModel(this.lat, this.lng) : super(lat, lng);
  factory GeoModel.fromJson(Map<String, dynamic> json) =>
      _$GeoModelFromJson(json);
  Map<String, dynamic> toJson() => _$GeoModelToJson(this);
}
