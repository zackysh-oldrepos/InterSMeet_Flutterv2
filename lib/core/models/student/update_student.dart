import 'package:intersmeet/core/models/user/update_user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'update_student.g.dart';

@JsonSerializable(explicitToJson: true)
class UpdateStudent {
  @JsonKey(name: 'updateUserDto')
  final UpdateUser updateUser;
  final DateTime birthDate;
  final int degreeId;
  final int averageGrades;

  UpdateStudent(
      {required this.birthDate,
      required this.degreeId,
      required this.averageGrades,
      required this.updateUser});

  factory UpdateStudent.fromJson(Map<String, dynamic> json) => _$UpdateStudentFromJson(json);
  Map<String, dynamic> toJson() => _$UpdateStudentToJson(this);
}
