import 'package:json_annotation/json_annotation.dart';

part 'update_user.g.dart';

@JsonSerializable()
class UpdateUser {
  final String username;
  final String firstName;
  final String lastName;
  final int provinceId;
  final String location;
  final int languageId;

  UpdateUser(
      {required this.username,
      required this.firstName,
      required this.lastName,
      required this.provinceId,
      required this.location,
      required this.languageId});

  factory UpdateUser.fromJson(Map<String, dynamic> json) => _$UpdateUserFromJson(json);
  Map<String, dynamic> toJson() => _$UpdateUserToJson(this);
}
