import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intersmeet/core/constants/hive.dart';
import 'package:intersmeet/core/exceptions/exception_handler.dart';
import 'package:intersmeet/core/models/user/user.dart';
import 'package:intersmeet/core/routes/navigation_service.dart';
import 'package:intersmeet/core/routes/routes.dart';
import 'package:intersmeet/core/services/authentication_service.dart';
import 'package:intersmeet/core/services/storage_service.dart';
import 'package:intersmeet/core/services/user_service.dart';

import 'core/interceptors/auth_interceptor.dart';

GetIt getIt = GetIt.instance;

void main() async {
  await initializeHive();
  addDependecyInjection();
  configureInterceptors();
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'InterSMeet',
        theme: ThemeData.dark(),
        debugShowCheckedModeBanner: false,
        navigatorKey: NavigationService.navigatorKey,
        initialRoute: '/welcome',
        routes: getApplicationRoutes());
  }
}

/// Register all Hive box-singletons in GetIt.
Future<void> initializeHive() async {
  await Hive.initFlutter();
  // Hive.deleteBoxFromDisk(authBox);
  Hive.registerAdapter(UserAdapter());
  getIt.registerSingleton<Box>(await Hive.openBox(authBox), instanceName: authBox);
}

void addDependecyInjection() {
  getIt.registerSingleton<StorageService>(StorageService());
  getIt.registerSingleton<Dio>(Dio());
  getIt.registerSingleton<ExceptionHandler>(ExceptionHandler());
  getIt.registerSingleton<UserService>(UserService());
  getIt.registerSingleton<AuthenticationService>(AuthenticationService());
}

void configureInterceptors() {
  var dio = getIt<Dio>();
  dio.interceptors.add(AuthInterceptor());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
