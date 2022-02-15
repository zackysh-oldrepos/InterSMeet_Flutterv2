// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Application _$ApplicationFromJson(Map<String, dynamic> json) => Application(
      offerId: json['offerId'] as int,
      name: json['name'] as String,
      status: $enumDecode(_$StatusEnumMap, json['status']),
      description: json['description'] as String,
      schedule: json['schedule'] as String?,
      salary: (json['salary'] as num).toDouble(),
      companyId: json['companyId'] as int,
      deadLine: DateTime.parse(json['deadLine'] as String),
    );

Map<String, dynamic> _$ApplicationToJson(Application instance) => <String, dynamic>{
      'offerId': instance.offerId,
      'name': instance.name,
      'status': _$StatusEnumMap[instance.status],
      'description': instance.description,
      'schedule': instance.schedule,
      'salary': instance.salary,
      'companyId': instance.companyId,
      'deadLine': instance.deadLine.toIso8601String(),
    };

const _$StatusEnumMap = {
  Status.denied: -1,
  Status.inProgress: 0,
  Status.accepted: 1,
};
