import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'application.g.dart';

@JsonEnum()
enum Status {
  @JsonValue(-1)
  denied,
  @JsonValue(0)
  inProgress,
  @JsonValue(1)
  accepted,
  @JsonValue(2)
  canceled,
}

Widget statusIcon(Status? status) {
  switch (status) {
    case Status.accepted:
      return const Icon(Icons.check_circle_outline, color: Colors.greenAccent);
    case Status.denied:
      return const Icon(Icons.cancel_outlined, color: Colors.redAccent);
    case Status.inProgress:
      return const Icon(Icons.pending_outlined, color: Colors.yellowAccent);
    case Status.canceled:
      return const Icon(Icons.cancel_presentation, color: Colors.redAccent);
    case null:
      return const SizedBox();
  }
}

statusValue(Status status) {
  switch (status) {
    case Status.denied:
      return "Denied";
    case Status.inProgress:
      return "In progress";
    case Status.accepted:
      return "Accepted";
    case Status.canceled:
      return "Canceled";
  }
}

@JsonSerializable(explicitToJson: true)
class Application {
  int offerId;
  int applicantCount;
  String name;
  Status status;
  String description;
  String? schedule;
  double salary;
  int companyId;
  DateTime deadLine;

  Application({
    required this.offerId,
    required this.applicantCount,
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
