import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intersmeet/core/exceptions/exception_handler.dart';
import 'package:intersmeet/core/routes/routes.dart';
import 'package:intersmeet/core/services/authentication_service.dart';
import 'package:intersmeet/core/services/user_service.dart';

import 'core/interceptors/auth_interceptor.dart';

GetIt getIt = GetIt.instance;

void main() async {
  addDependecyInjection();
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'InterSMeet',
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: getApplicationRoutes());
  }
}

void addDependecyInjection() {
  getIt.registerSingleton<UserService>(UserService());
  getIt.registerSingleton<ExceptionHandler>(ExceptionHandler());
  getIt.registerSingleton<Dio>(configureDio());
  getIt.registerSingleton<AuthenticationService>(AuthenticationService());
}

Dio configureDio() {
  var dio = Dio();
  dio.interceptors.add(AuthInterceptor());
  return dio;
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
