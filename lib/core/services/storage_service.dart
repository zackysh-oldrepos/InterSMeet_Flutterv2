import 'package:hive_flutter/hive_flutter.dart';
import 'package:intersmeet/core/constants/hive.dart';
import 'package:intersmeet/core/models/user/auth/auth_response.dart';
import 'package:intersmeet/core/models/user/user.dart';

import '../../main.dart';

class StorageService {
  final _authBox = getIt<Box>(instanceName: authBox);

  // -------------------------------------------------------------------------------------
  // @ Secure
  // -------------------------------------------------------------------------------------

  String? getAccessToken() {
    return _authBox.get(accessTokenKey);
  }

  String? getRefreshToken() {
    return _authBox.get(refreshTokenKey);
  }

  void setAccessToken(String accessToken) {
    _authBox.put(accessTokenKey, accessToken);
  }

  void setRefreshToken(String refreshToken) {
    _authBox.put(refreshTokenKey, refreshToken);
  }

  // -------------------------------------------------------------------------------------
  // @ Shared
  // -------------------------------------------------------------------------------------

  User? getUser() {
    return _authBox.get(userKey);
  }

  void setUser(User? user) {
    if (user != null) _authBox.delete(userKey);
    _authBox.put(userKey, user);
  }

  bool? getRememberMe() {
    return _authBox.get(rememberMeKey);
  }

  void setRememberMe(bool rememberMe) {
    _authBox.put(rememberMeKey, rememberMe);
  }

  void storeSessionData(AuthResponse auth, bool? rememberMe) {
    // save tokens
    if (auth.accessToken != null) setAccessToken(auth.accessToken!);
    if (auth.refreshToken != null) setRefreshToken(auth.refreshToken!);
    // save user session
    if (rememberMe != null) setRememberMe(rememberMe);
    setUser(auth.user);
  }
}
