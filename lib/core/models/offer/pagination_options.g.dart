// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination_options.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginationOptions _$PaginationOptionsFromJson(Map<String, dynamic> json) => PaginationOptions(
      page: json['page'] as int,
      size: json['size'] as int,
      skipExpired: json['skipExpired'] as bool? ?? true,
      privateData: json['privateData'] as bool? ?? false,
      search: json['search'] as String?,
      companyId: json['companyId'] as int?,
      degreeId: json['degreeId'] as int?,
      familyId: json['familyId'] as int?,
      levelId: json['levelId'] as int?,
      min: (json['min'] as num?)?.toDouble(),
      max: (json['max'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$PaginationOptionsToJson(PaginationOptions instance) => <String, dynamic>{
      'page': instance.page,
      'size': instance.size,
      'skipExpired': instance.skipExpired,
      'privateData': instance.privateData,
      'search': instance.search,
      'companyId': instance.companyId,
      'degreeId': instance.degreeId,
      'familyId': instance.familyId,
      'levelId': instance.levelId,
      'min': instance.min,
      'max': instance.max,
    };
