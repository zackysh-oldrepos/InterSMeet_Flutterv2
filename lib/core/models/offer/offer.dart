import 'package:json_annotation/json_annotation.dart';

part 'offer.g.dart';

@JsonSerializable(explicitToJson: true)
class Offer {
  int offerId;
  String name;
  String description;
  String? schedule;
  double salary;
  int companyId;
  DateTime deadLine;

  Offer({
    required this.offerId,
    required this.name,
    required this.description,
    this.schedule,
    required this.salary,
    required this.companyId,
    required this.deadLine,
  });

  factory Offer.fromJson(Map<String, dynamic> json) => _$OfferFromJson(json);
  Map<String, dynamic> toJson() => _$OfferToJson(this);
}
