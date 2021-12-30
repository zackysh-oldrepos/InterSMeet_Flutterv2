import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intersmeet/core/constants/api_constants.dart';
import 'package:intersmeet/core/models/user/student_sign_up.dart';
import 'package:intersmeet/core/models/user/user.dart';
import 'package:rxdart/rxdart.dart';

import '../../main.dart';

class AuthenticationService {
  late FlutterSecureStorage _storage;
  final BehaviorSubject<User> _user$ = BehaviorSubject();
  final dio = getIt<Dio>();

  AuthenticationService() {
    _storage = const FlutterSecureStorage();
  }

  Future<int> signIn(String credential, String password, bool rememberMe) async {
    var res = await dio.post(
      "$apiUrl/users/sign-in",
      data: jsonEncode({'credential': credential, 'password': password}),
    );

    if (res.statusCode == 200) {
      await setAccessToken(res.data["accessToken"]);
      await setRefreshToken(res.data["accessToken"]);
      await setUser$(User.fromJson(res.data['user']));
      await setRememberMe(rememberMe);
      return 0;
    } // exception missing
    return res.statusCode ?? 500; // return status for validation
  }

  Future<bool> signUp(StudentSignUp signUp) async {
    var res = await dio.post("$apiUrl/users/sign-up/student", data: jsonEncode(signUp.toJson()));
    if (res.statusCode == 200) {
      await setAccessToken(res.data["accessToken"]);
      await setRefreshToken(res.data["accessToken"]);
      await setUser$(User.fromJson(res.data['user']));
      return true;
    } // exception missing
    return false;
  }

  // -------------------------------------------------------------------------------------
  // @ Session management
  // -------------------------------------------------------------------------------------

  ValueStream<User> getUser$() {
    return _user$.stream;
  }

  setUser$(User user) {
    _user$.add(user);
  }

  User getCurrentUser() {
    return _user$.value;
  }

  Future<bool?> getRememberMe() async {
    var rememberMe = await _storage.read(key: rememberMeKey);
    rememberMe.runtimeType == bool ? rememberMe as bool : false;
  }

  setRememberMe(bool rememberMe) async {
    await _storage.write(key: rememberMeKey, value: jsonEncode(rememberMe));
    return;
  }

  // -------------------------------------------------------------------------------------
  // @ Token management
  // -------------------------------------------------------------------------------------

  Future<String?> getAccessToken() async {
    return await _storage.read(key: accessTokenKey);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: refreshTokenKey);
  }

  Future<void> setAccessToken(String accessToken) async {
    await _storage.write(key: accessTokenKey, value: accessToken);
    return;
  }

  Future<void> setRefreshToken(String refreshToken) async {
    await _storage.write(key: refreshTokenKey, value: refreshToken);
    return;
  }

  Future<bool> refreshToken() async {
    String? refreshToken = await getRefreshToken();
    if (refreshToken == null) return false;

    var res = await http.post(Uri.parse("$apiUrl/users/refresh-access-token"),
        headers: {'Authorization': 'Bearer $refreshToken)'});

    if (res.statusCode == 401) return false;
    if (res.statusCode == 200) return true;
    return false; // exception handling missing
  }

  // -------------------------------------------------------------------------------------
  // @ Validation
  // -------------------------------------------------------------------------------------

  Future<bool> checkUsername(String username) async {
    var res = await http.post(Uri.parse("$apiUrl/users/check/username?username=$username"));
    return res.statusCode == 200; // exception missing
  }

  Future<bool> checkEmail(String email) async {
    var res = await http.post(Uri.parse("$apiUrl/users/check/email/?email=$email"));
    return res.statusCode == 200;
  }
}
