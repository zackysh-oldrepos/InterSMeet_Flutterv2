import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intersmeet/core/exceptions/exception_handler.dart';
import 'package:intersmeet/core/routes/routes.dart';
import 'package:intersmeet/core/services/authentication_service.dart';

GetIt getIt = GetIt.instance;

void main() async {
  addDependecyInjection();
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
  getIt.registerSingleton<AuthenticationService>(AuthenticationService());
  getIt.registerSingleton<ExceptionHandler>(ExceptionHandler());
}
