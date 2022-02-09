import '../user.dart';

class AuthResponse {
  final String? accessToken;
  final String? refreshToken;
  final User user;

  AuthResponse({this.accessToken, this.refreshToken, required this.user});
}
