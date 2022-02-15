import 'package:json_annotation/json_annotation.dart';

part 'application.g.dart';

@JsonEnum()
enum Status {
  @JsonValue(-1)
  denied,
  @JsonValue(0)
  inProgress,
  @JsonValue(1)
  accepted
}

@JsonSerializable(explicitToJson: true)
class Application {
  int offerId;
  String name;
  Status status;
  String description;
  String? schedule;
  double salary;
  int companyId;
  DateTime deadLine;

  Application({
    required this.offerId,
    required this.name,
    required this.status,
    required this.description,
    this.schedule,
    required this.salary,
    required this.companyId,
    required this.deadLine,
  });

  factory Application.fromJson(Map<String, dynamic> json) => _$ApplicationFromJson(json);
  Map<String, dynamic> toJson() => _$ApplicationToJson(this);
}
