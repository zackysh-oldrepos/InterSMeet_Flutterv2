// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unused_element

part of 'company.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Company _$CompanyFromJson(Map<String, dynamic> json) => Company(
      companyId: json['companyId'] as int,
      companyName: json['companyName'] as String,
      address: json['address'] as String,
    );

Map<String, dynamic> _$CompanyToJson(Company instance) => <String, dynamic>{
      'companyId': instance.companyId,
      'companyName': instance.companyName,
      'address': instance.address,
    };
