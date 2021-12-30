import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final int userId;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final int provinceId;
  final String location;
  final int languageId;

  User(
      {required this.userId,
      required this.username,
      required this.email,
      required this.firstName,
      required this.lastName,
      required this.provinceId,
      required this.location,
      required this.languageId});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

class AuthResponse {
  final User user;
  final String accessToken;
  final String refreshToken;

  AuthResponse(this.user, this.accessToken, this.refreshToken);
}
