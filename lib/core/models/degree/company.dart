import 'package:json_annotation/json_annotation.dart';

part 'company.g.dart';

@JsonSerializable()
class Company {
  final int companyId;
  final String companyName;
  final String address;

  Company({required this.companyId, required this.companyName, required this.address});
  factory Company.fromJson(Map<String, dynamic> json) => _$CompanyFromJson(json);
}
