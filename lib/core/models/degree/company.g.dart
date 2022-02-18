// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Company _$CompanyFromJson(Map<String, dynamic> json) => Company(
      companyId: json['companyId'] as int,
      companyName: json['companyName'] as String,
      address: json['address'] as String,
    );

// ignore: unused_element
Map<String, dynamic> _$CompanyToJson(Company instance) => <String, dynamic>{
      'companyId': instance.companyId,
      'companyName': instance.companyName,
      'address': instance.address,
    };
