import 'package:intersmeet/core/models/offer/application.dart';
import 'package:json_annotation/json_annotation.dart';

part 'offer.g.dart';

@JsonSerializable(explicitToJson: true)
class Offer {
  int offerId;
  int applicantCount;
  String name;
  String description;
  String? schedule;
  double salary;
  int companyId;
  DateTime deadLine;

  Offer({
    required this.offerId,
    required this.applicantCount,
    required this.name,
    required this.description,
    this.schedule,
    required this.salary,
    required this.companyId,
    required this.deadLine,
  });

  static Offer fromApplication(Application application) {
    return Offer(
      offerId: application.offerId,
      applicantCount: application.applicantCount,
      name: application.name,
      description: application.description,
      salary: application.salary,
      companyId: application.companyId,
      deadLine: application.deadLine,
    );
  }

  factory Offer.fromJson(Map<String, dynamic> json) => _$OfferFromJson(json);
  Map<String, dynamic> toJson() => _$OfferToJson(this);
}
