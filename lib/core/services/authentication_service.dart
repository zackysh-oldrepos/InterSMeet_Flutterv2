import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:intersmeet/core/constants/api_constants.dart';
import 'package:intersmeet/core/models/user/user.dart';

class AuthenticationService {
  late FlutterSecureStorage _storage;

  AuthenticationService() {
    _storage = const FlutterSecureStorage();
  }

  Future<Response?> signIn(String credential, String password) async {
    return await http.post(Uri.parse("$apiUrl/users/sign-in"),
        body: jsonEncode({'credential': credential, 'password': password}),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"
        });
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: accessTokenKey);
  }

  Future<User?> signInUsingToken() async {
    String? token = await getAccessToken();
    if (token == null) return null;

    // var res = await Dio().post("$apiUrl/users/refresh-access-token",
    // headers: {'Authorization': 'Bearer $token)'});

    // if (res.statusCode == 200) return res.body as User;
    return null;
  }
}

class SignInResponse {
  final User user;
  final String accessToken;
  final String refreshToken;

  SignInResponse(this.user, this.accessToken, this.refreshToken);
}
