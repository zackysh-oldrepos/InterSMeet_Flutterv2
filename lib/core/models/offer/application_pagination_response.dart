import 'package:intersmeet/core/models/offer/pagination_options.dart';
import 'package:json_annotation/json_annotation.dart';

import 'application.dart';

part 'application_pagination_response.g.dart';

@JsonSerializable(explicitToJson: true)
class ApplicationPaginationResponse {
  final PaginationOptions pagination;
  final List<Application> results;

  ApplicationPaginationResponse({
    required this.pagination,
    required this.results,
  });

  factory ApplicationPaginationResponse.fromJson(Map<String, dynamic> json) =>
      _$ApplicationPaginationResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ApplicationPaginationResponseToJson(this);
}
