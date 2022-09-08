
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user.dart';
import 'address_model.dart';
import 'company_model.dart';
part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends User {
  final int id;
  final String name;
  final CompanyModel company;
  final AddressModel address;
  final String username;
  final String email;
  final String phone;
  final String website;

  const UserModel(this.id, this.name, this.username, this.email, this.phone,
      this.website, this.company, this.address)
      : super(id, name, username, phone, email, website, address, company);
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
