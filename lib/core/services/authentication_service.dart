import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:intersmeet/core/constants/api.dart';
import 'package:intersmeet/core/models/user/student_sign_up.dart';
import 'package:intersmeet/core/models/user/user.dart';
import 'package:intersmeet/core/services/storage_service.dart';

import '../../main.dart';

class AuthenticationService {
  final _storageService = getIt<StorageService>();
  final _dio = getIt<Dio>();

  // =======================================================================
  // @ Session
  // =======================================================================

  /// Try to sign-in. Returns 200 if sign-in was successful,
  /// 404 if user doesn't exists and 401 if password is wrong.
  Future<int> signIn(String credential, String password, bool rememberMe) async {
    Response res = await _dio.post(
      "$apiUrl/users/sign-in/student",
      data: jsonEncode({'credential': credential, 'password': password}),
    );

    if (res.statusCode == 200) {
      _storeSessionData(res, rememberMe);
      return 0;
    } // exception missing

    return res.statusCode ?? 500; // return status for validation
  }

  /// Try to refresh access-token. Returns true on success, false on failure.
  Future<bool> refreshToken() async {
    String? refreshToken = _storageService.getRefreshToken();
    if (refreshToken == null) return false;

    var res = await http.post(Uri.parse("$apiUrl/users/refresh-access-token"),
        headers: {'Authorization': 'Bearer $refreshToken)'});

    if (res.statusCode == 401) return false;
    if (res.statusCode == 200) return true;
    return false; // exception handling missing
  }

  void logOut() {
    _storageService.setAccessToken("");
    _storageService.setRefreshToken("");
    _storageService.setRememberMe(false);
    _storageService.setUser(null);
  }

  /// Returns true if remember-me is true and session is valid.
  Future<bool> isSessionActive() async {
    var rememberMe = _storageService.getRememberMe();

    if (rememberMe == null || !rememberMe) return false;
    return await isSessionValid();
  }

  /// Check if current access token is valid, if not, try to refresh it.
  /// If any of this steps fails, returns false, if not, returns true.
  Future<bool> isSessionValid() async {
    // @ Check access token
    var isATValid = await _dio.post("$apiUrl/users/check-access");
    // exception missing in case status != 200 && != 401
    if (isATValid.statusCode == 200) return true;
    return await refreshToken();
  }

  User? getUser() {
    return _storageService.getUser();
  }

  Future<List<int>?> loadAvatar() async {
    var accessToken = _storageService.getAccessToken();
    var res = await _dio.get(
      "$apiUrl/students/download-avatar",
      options: Options(
        headers: {"Authorization": "Bearer $accessToken"},
        responseType: ResponseType.bytes,
      ),
    );

    return res.statusCode == 200 ? res.data : null;
  }

  // =======================================================================
  // @ Registration
  // =======================================================================

  /// Try to sign-up. Returns true is sign-up was successful or false if it isn't.
  Future<bool> signUp(StudentSignUp signUp) async {
    var res = await _dio.post("$apiUrl/users/sign-up/student", data: jsonEncode(signUp.toJson()));
    if (res.statusCode == 200) {
      _storeSessionData(res, false);
      return true;
    } // exception missing
    return false;
  }

  // @ Email Verification

  Future<int> sendEmailVerificationCode() async {
    // TODO get session access token
    String? accessToken =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoidGVzdHgiLCJqdGkiOiJlNzg2Mzc3Yi1mZTI1LTQ5ODktODA4Yy1hOWIwOWU1YjVmNDYiLCJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3JvbGUiOiJTdHVkZW50IiwiZXhwIjoxNjQ0MTIxNDk4LCJpc3MiOiJsb2NhbGhvc3Q6YmFjayIsImF1ZCI6ImxvY2FsaG9zdDpmcm9udCJ9.qfNsF4H68DBeN3sE8KD0KzIC_YclwRl7QrLkmCbkFho";

    // users/send-confirm-email
    var res = await _dio.post(
      "$apiUrl/users/send-confirm-email",
      options: Options(headers: {"Authorization": "Bearer $accessToken"}),
    );

    return res.statusCode ?? 500;
  }

  Future<int> emailVerification(String verificationCode) async {
    String? accessToken =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoidGVzdHgiLCJqdGkiOiJlNzg2Mzc3Yi1mZTI1LTQ5ODktODA4Yy1hOWIwOWU1YjVmNDYiLCJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3JvbGUiOiJTdHVkZW50IiwiZXhwIjoxNjQ0MTIxNDk4LCJpc3MiOiJsb2NhbGhvc3Q6YmFjayIsImF1ZCI6ImxvY2FsaG9zdDpmcm9udCJ9.qfNsF4H68DBeN3sE8KD0KzIC_YclwRl7QrLkmCbkFho";

    // users/send-confirm-email
    var res = await _dio.post(
      "$apiUrl/users/confirm-email/$verificationCode",
      options: Options(headers: {"Authorization": "Bearer $accessToken"}),
    );

    return res.statusCode ?? 500;
  }

  // @ Validation

  /// Ask to API if provided username is available.
  Future<bool> checkUsername(String username) async {
    var res = await http.post(Uri.parse("$apiUrl/users/check/username?username=$username"));
    return res.statusCode == 200; // exception missing
  }

  /// Ask to API if provided email is available.
  Future<bool> checkEmail(String email) async {
    var res = await http.post(Uri.parse("$apiUrl/users/check/email/?email=$email"));
    return res.statusCode == 200;
  }

  // =======================================================================
  // @ Private methods
  // =======================================================================

  void _storeSessionData(Response res, bool rememberMe) async {
    // save tokens
    _storageService.setAccessToken(res.data["accessToken"]);
    _storageService.setRefreshToken(res.data["refreshToken"]);
    // save user session
    _storageService.setRememberMe(rememberMe);
    var user = User.fromJson(res.data["user"]);

    var avatar = await loadAvatar();
    if (avatar != null) {
      var _user = user..avatar = avatar;
      _storageService.setUser(_user);
    } else {
      _storageService.setUser(user);
    }
  }
}
