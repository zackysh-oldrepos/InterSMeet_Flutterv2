import 'package:intersmeet/core/models/offer/offer.dart';
import 'package:intersmeet/core/models/offer/pagination_options.dart';
import 'package:json_annotation/json_annotation.dart';

part 'offer_pagination_response.g.dart';

@JsonSerializable(explicitToJson: true)
class OfferPaginationResponse {
  final PaginationOptions pagination;
  final List<Offer> results;
  final int total;

  OfferPaginationResponse({
    required this.pagination,
    required this.results,
    required this.total,
  });

  factory OfferPaginationResponse.fromJson(Map<String, dynamic> json) =>
      _$OfferPaginationResponseFromJson(json);
  Map<String, dynamic> toJson() => _$OfferPaginationResponseToJson(this);
}
