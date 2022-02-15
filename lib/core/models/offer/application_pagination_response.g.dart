// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_pagination_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApplicationPaginationResponse _$ApplicationPaginationResponseFromJson(Map<String, dynamic> json) =>
    ApplicationPaginationResponse(
      pagination: PaginationOptions.fromJson(json['pagination'] as Map<String, dynamic>),
      results: (json['results'] as List<dynamic>)
          .map((e) => Application.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ApplicationPaginationResponseToJson(
        ApplicationPaginationResponse instance) =>
    <String, dynamic>{
      'pagination': instance.pagination.toJson(),
      'results': instance.results.map((e) => e.toJson()).toList(),
    };
