// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offer_pagination_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OfferPaginationResponse _$OfferPaginationResponseFromJson(Map<String, dynamic> json) =>
    OfferPaginationResponse(
      pagination: PaginationOptions.fromJson(json['pagination'] as Map<String, dynamic>),
      results: (json['results'] as List<dynamic>)
          .map((e) => Offer.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int,
    );

Map<String, dynamic> _$OfferPaginationResponseToJson(OfferPaginationResponse instance) =>
    <String, dynamic>{
      'pagination': instance.pagination.toJson(),
      'results': instance.results.map((e) => e.toJson()).toList(),
      'total': instance.total,
    };
