// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:intersmeet/core/routes/navigation_service.dart';
import 'package:intersmeet/core/services/storage_service.dart';
import 'package:intersmeet/main.dart';

class AuthInterceptor extends Interceptor {
  final _tokenService = getIt<StorageService>();
  // final _authService = getIt<AuthenticationService>();

  AuthInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // @ Headers
    String? accessToken = _tokenService.getAccessToken();
    if (!options.headers.containsKey('Authorization') &&
        accessToken != null &&
        accessToken.isNotEmpty) {
      options.headers.addAll({"Authorization": "Bearer $accessToken"});
    }
    if (!options.headers.containsKey('Content-Type')) {
      options.headers.addAll({
        "Content-Type": "application/json",
      });
    }
    // @ Dio options
    options.followRedirects = false;

    handler.next(options);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (NavigationService.navigatorKey.currentContext != null) {
      // ignore: todo
      // TODO implement refresh-token instead of navigation
      // error logs could be sent to API here
      // _authService.logOut();
      // Navigator.of(NavigationService.navigatorKey.currentContext!)
      //     .pushNamedAndRemoveUntil('/welcome', (route) => false);
      log("======================");
      print(err);
      log(err.message);
      print(err.response);
      log("======================");
      throw err;
    }
  }
}
