// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_student.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateStudent _$UpdateStudentFromJson(Map<String, dynamic> json) => UpdateStudent(
      birthDate: DateTime.parse(json['birthDate'] as String),
      degreeId: json['degreeId'] as int,
      averageGrades: json['averageGrades'] as int,
      updateUser: UpdateUser.fromJson(json['updateUserDto'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UpdateStudentToJson(UpdateStudent instance) => <String, dynamic>{
      'updateUserDto': instance.updateUser.toJson(),
      'birthDate': instance.birthDate.toIso8601String(),
      'degreeId': instance.degreeId,
      'averageGrades': instance.averageGrades,
    };
