import 'package:json_annotation/json_annotation.dart';

part 'pagination_options.g.dart';

@JsonSerializable(explicitToJson: true)
class PaginationOptions {
  int page; // buttons [x]
  int size; // dropdown [x]
  bool? skipExpired; // check-box [x]
  bool? privateData;
  String? search; // search-bar [x]
  // @ Filters
  int? companyId; // search-dropdown [x]
  int? degreeId; // search-dropdown [x]
  int? familyId; // search-dropdown [x]
  int? levelId; // dropdown [x]
  // @ Salary Filter
  double? min; // range [x]
  double? max; // range [x]

  PaginationOptions({
    required this.page,
    required this.size,
    this.skipExpired = true,
    this.privateData = false,
    this.search,
    // @ Filters
    this.companyId,
    this.degreeId,
    this.familyId,
    this.levelId,
    // @ Salary Filter
    this.min,
    this.max,
  });

  factory PaginationOptions.fromJson(Map<String, dynamic> json) =>
      _$PaginationOptionsFromJson(json);
  Map<String, dynamic> toJson() => _$PaginationOptionsToJson(this);
}
