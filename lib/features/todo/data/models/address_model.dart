import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/adress.dart';
import 'geo_model.dart';
part 'address_model.g.dart';


@JsonSerializable()
class AddressModel extends Address {
  final String street;
  final GeoModel geo;
  final String suite;
  final String city;
  final String zipcode;

  const AddressModel(this.street, this.suite, this.city, this.zipcode, this.geo)
      : super(
          street,
          suite,
          city,
          zipcode,
          geo,
        );
  factory AddressModel.fromJson(Map<String, dynamic> json) =>
      _$AddressModelFromJson(json);
  Map<String, dynamic> toJson() => _$AddressModelToJson(this);
}
