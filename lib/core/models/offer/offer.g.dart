// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Offer _$OfferFromJson(Map<String, dynamic> json) => Offer(
      offerId: json['offerId'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      schedule: json['schedule'] as String?,
      salary: (json['salary'] as num).toDouble(),
      companyId: json['companyId'] as int,
      deadLine: DateTime.parse(json['deadLine'] as String),
    );

Map<String, dynamic> _$OfferToJson(Offer instance) => <String, dynamic>{
      'offerId': instance.offerId,
      'name': instance.name,
      'description': instance.description,
      'schedule': instance.schedule,
      'salary': instance.salary,
      'companyId': instance.companyId,
      'deadLine': instance.deadLine.toIso8601String(),
    };
