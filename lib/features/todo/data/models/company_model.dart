
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/company.dart';
part 'company_model.g.dart';

@JsonSerializable()
class CompanyModel extends Company {
  final String name;
  final String catchPhrase;
  final String bs;

  const CompanyModel(this.name, this.catchPhrase, this.bs)
      : super(
          name,
          catchPhrase,
          bs,
        );
  factory CompanyModel.fromJson(Map<String, dynamic> json) =>
      _$CompanyModelFromJson(json);
  Map<String, dynamic> toJson() => _$CompanyModelToJson(this);
}
