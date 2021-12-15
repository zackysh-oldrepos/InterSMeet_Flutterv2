import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:intersmeet/core/constants/api_constants.dart';
import 'package:intersmeet/core/models/user/user.dart';

class AuthenticationService {
  late FlutterSecureStorage _storage;

  AuthenticationService() {
    _storage = const FlutterSecureStorage();
  }

  Future<Response?> signIn(String credential, String password) async {
    try {
      return await Dio().post("$apiUrl/users/sign-in",
          data: {'credential': credential, 'password': password});
    } on DioError catch (err) {
      if (err.type == DioErrorType.other) {
        log(err.toString());
        rethrow;
      }

      return err.response;
    }
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
