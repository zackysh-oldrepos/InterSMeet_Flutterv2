import 'package:json_annotation/json_annotation.dart';

part 'user_sign_up.g.dart';

@JsonSerializable()
class UserSignUp {
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final int provinceId;
  final String location;
  final String password;
  final int languageId;

  UserSignUp(
      {required this.username,
      required this.email,
      required this.firstName,
      required this.lastName,
      required this.provinceId,
      required this.location,
      required this.password,
      required this.languageId});

  factory UserSignUp.fromJson(Map<String, dynamic> json) => _$UserSignUpFromJson(json);
  Map<String, dynamic> toJson() => _$UserSignUpToJson(this);
}
