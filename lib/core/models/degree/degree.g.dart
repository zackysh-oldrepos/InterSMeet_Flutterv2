// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unused_element

part of 'degree.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Degree _$DegreeFromJson(Map<String, dynamic> json) => Degree(
      degreeId: json['degreeId'] as int,
      name: json['name'] as String,
      levelId: json['levelId'] as int,
      familyId: json['familyId'] as int,
    );

Map<String, dynamic> _$DegreeToJson(Degree instance) => <String, dynamic>{
      'degreeId': instance.degreeId,
      'name': instance.name,
      'levelId': instance.levelId,
      'familyId': instance.familyId,
    };
