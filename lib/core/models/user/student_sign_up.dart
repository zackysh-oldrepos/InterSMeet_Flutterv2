import 'package:intersmeet/core/models/user/user_sign_up.dart';
import 'package:json_annotation/json_annotation.dart';

part 'student_sign_up.g.dart';

@JsonSerializable(explicitToJson: true)
class StudentSignUp {
  @JsonKey(name: 'userSignUpDto')
  final UserSignUp userSignUp;
  final DateTime birthDate;
  final int degreeId;
  final double averageGrades;

  StudentSignUp(
      {required this.birthDate,
      required this.degreeId,
      required this.averageGrades,
      required this.userSignUp});

  factory StudentSignUp.fromJson(Map<String, dynamic> json) => _$StudentSignUpFromJson(json);
  Map<String, dynamic> toJson() => _$StudentSignUpToJson(this);
}
