import 'package:json_annotation/json_annotation.dart';

part 'degree.g.dart';

@JsonSerializable()
class Degree {
  final int degreeId;
  final String name;
  final int levelId;
  final int familyId;

  Degree(
      {required this.degreeId, required this.name, required this.levelId, required this.familyId});

  factory Degree.fromJson(Map<String, dynamic> json) => _$DegreeFromJson(json);
}
