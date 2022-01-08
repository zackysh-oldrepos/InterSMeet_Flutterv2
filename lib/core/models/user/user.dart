import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

import '../degree.dart';

part 'user.g.dart';

@JsonSerializable()
@HiveType(typeId: 0)
class User {
  @HiveField(0)
  final int userId;
  @HiveField(1)
  final String username;
  @HiveField(2)
  final String email;
  @HiveField(3)
  final String firstName;
  @HiveField(4)
  final String lastName;
  @HiveField(5)
  final int provinceId;
  @HiveField(6)
  final String location;
  @HiveField(7)
  final int languageId;

  // @ Student details
  @HiveField(8)
  final int degreeId;
  @HiveField(11)
  final int averageGrades;
  @HiveField(10)
  final String birthDate;
  @JsonKey(ignore: true)
  @HiveField(9)
  List<int>? avatar;
  @JsonKey(ignore: true)
  Degree? degree;

  User({
    required this.userId,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.provinceId,
    required this.location,
    required this.languageId,
    // @ Student details
    required this.degreeId,
    required this.birthDate,
    required this.averageGrades,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
