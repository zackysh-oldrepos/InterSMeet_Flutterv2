import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:intersmeet/core/constants/api.dart';
import 'package:intersmeet/core/models/student/student_sign_up.dart';
import 'package:intersmeet/core/models/user/auth/auth_response.dart';
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
      options: Options(
        validateStatus: (status) => status != 500,
      ),
    );

    if (res.statusCode == 200) {
      await _storeSessionData(res, rememberMe);
      return 0;
    }

    // return fail status
    return res.statusCode ?? 500;
  }

  /// Try to refresh access-token. Returns true on success, false on failure.
  Future<bool> refreshToken() async {
    String? refreshToken = _storageService.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) return false;

    var res = await _dio.post(
      "$apiUrl/users/refresh",
      options: Options(
        headers: {'refresh-token': refreshToken},
        validateStatus: (status) => status == 200 || status == 401,
      ),
    );

    if (res.statusCode == 200) return true;
    return false;
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
    var isATValid = await _dio.post(
      "$apiUrl/users/check-access",
      options: Options(
        validateStatus: (status) => status == 200 || status == 401,
      ),
    );

    if (isATValid.statusCode == 200) return true;
    return await refreshToken();
  }

  User? getUser() {
    return _storageService.getUser();
  }

  Future<List<int>?> loadAvatar(String? newAccessToken) async {
    var accessToken = newAccessToken ?? _storageService.getAccessToken();
    var res = await _dio.get(
      "$apiUrl/students/download-avatar",
      options: Options(
        headers: {"Authorization": "Bearer $accessToken"},
        responseType: ResponseType.bytes,
      ),
    );

    return res.data;
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
    }
    return false;
  }

  // @ Email Verification

  Future<int> sendEmailVerificationCode() async {
    var res = await _dio.post(
      "$apiUrl/users/send-confirm-email",
      options: Options(
        validateStatus: (status) => status == 200 || status == 409,
      ),
    );

    return res.statusCode ?? 500;
  }

  Future<int> emailVerification(String verificationCode) async {
    var res = await _dio.post(
      "$apiUrl/users/confirm-email/$verificationCode",
      options: Options(
        validateStatus: (status) => status == 200 || status == 403,
      ),
    );
    return res.statusCode ?? 500;
  }

  // @ Restore Password

  Future<int> sendRestorePasswordCode(String credential) async {
    var res = await _dio.post("$apiUrl/users/send-restore-password/$credential");
    return res.statusCode ?? 500;
  }

  Future<int> checkRestorePasswordCode(String credential, String restorePasswordCode) async {
    var res = await _dio.post(
      "$apiUrl/users/check-restore-password",
      data: {
        "credential": credential,
        "restorePasswordCode": restorePasswordCode,
      },
      options: Options(
        validateStatus: (status) => status == 200 || status == 403,
      ),
    );
    return res.statusCode ?? 500;
  }

  Future<int> restorePassword(
    String credential,
    String newPassword,
    String restorePasswordCode,
  ) async {
    var res = await _dio.post("$apiUrl/users/restore-password", data: {
      "restorePasswordCode": restorePasswordCode,
      "credential": credential,
      "newPassword": newPassword
    });
    return res.statusCode ?? 500;
  }

  // @ Validation

  /// Ask to API if provided username `is available`.
  Future<bool> checkUsername(String username) async {
    var res = await _dio.post("$apiUrl/users/check/username?username=$username");
    return res.statusCode == 200; // exception missing
  }

  /// Ask to API if provided email `is available`.
  Future<bool> checkEmail(String email) async {
    var res = await _dio.post(
      "$apiUrl/users/check/email/?email=$email",
      options: Options(
        validateStatus: (status) => status == 200 || status == 409,
      ),
    );
    return res.statusCode == 200;
  }

  /// Ask to API if provided email or username `is available`.
  Future<bool> checkCredential(String credential) async {
    var res = await _dio.post(
      "$apiUrl/users/check/credential/?credential=$credential",
      options: Options(
        validateStatus: (status) => status == 200 || status == 409,
      ),
    );
    return res.statusCode == 200;
  }

  // =======================================================================
  // @ Private methods
  // =======================================================================

  Future<void> _storeSessionData(Response res, bool rememberMe) async {
    var user = User.fromJson(res.data["user"]);
    var accessToken = res.data["accessToken"];
    var refreshToken = res.data["refreshToken"];
    var avatar = await loadAvatar(accessToken);
    if (avatar != null) user.avatar = avatar;

    _storageService.storeSessionData(
      AuthResponse(accessToken: accessToken, refreshToken: refreshToken, user: user),
      rememberMe,
    );
  }
}
