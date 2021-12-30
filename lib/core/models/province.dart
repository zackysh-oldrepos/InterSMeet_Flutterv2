import 'package:json_annotation/json_annotation.dart';

part 'province.g.dart';

@JsonSerializable()
class Province {
  final int provinceId;
  final String name;

  Province(this.provinceId, this.name);

  factory Province.fromJson(Map<String, dynamic> json) => _$ProvinceFromJson(json);
}
