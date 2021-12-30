// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_sign_up.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudentSignUp _$StudentSignUpFromJson(Map<String, dynamic> json) => StudentSignUp(
      birthDate: DateTime.parse(json['birthDate'] as String),
      degreeId: json['degreeId'] as int,
      averageGrades: (json['averageGrades'] as num).toDouble(),
      userSignUp: UserSignUp.fromJson(json['userSignUpDto'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StudentSignUpToJson(StudentSignUp instance) => <String, dynamic>{
      'userSignUpDto': instance.userSignUp.toJson(),
      'birthDate': instance.birthDate.toIso8601String(),
      'degreeId': instance.degreeId,
      'averageGrades': instance.averageGrades,
    };
