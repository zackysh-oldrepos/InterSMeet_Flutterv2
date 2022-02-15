import 'package:json_annotation/json_annotation.dart';

part 'family.g.dart';

@JsonSerializable()
class Family {
  final int familyId;
  final String name;

  Family({required this.familyId, required this.name});
  factory Family.fromJson(Map<String, dynamic> json) => _$FamilyFromJson(json);
}
