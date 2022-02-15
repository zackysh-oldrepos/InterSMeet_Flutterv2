// ignore_for_file: avoid_print, dead_code
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intersmeet/core/routes/navigation_service.dart';
import 'package:intersmeet/core/services/authentication_service.dart';
import 'package:intersmeet/core/services/storage_service.dart';
import 'package:intersmeet/main.dart';

class AuthInterceptor extends Interceptor {
  final _tokenService = getIt<StorageService>();
  final _authService = getIt<AuthenticationService>();
  final _dio = getIt<Dio>();
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
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // ignore: fixme
      return _navigateWelcome(); // FIXME Api dont recognize expired tokens
      // if (!await _authService.refreshToken()) return _navigateWelcome();

      RequestOptions requestOptions = err.requestOptions;
      final response = await _dio.request(
        requestOptions.path,
        options: Options(method: requestOptions.method),
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
      );

      handler.resolve(response);
    } else {
      print(err.response);
      handler.next(err);
    }
  }

  void _navigateWelcome() {
    if (NavigationService.navigatorKey.currentContext != null) {
      Navigator.of(NavigationService.navigatorKey.currentContext!).pushNamedAndRemoveUntil(
        '/welcome',
        (route) => false,
      );
      ScaffoldMessenger.of(NavigationService.navigatorKey.currentContext!).showSnackBar(
        const SnackBar(
          content: Text('Your session has expired, sign in again'),
        ),
      );
    }
  }
}
