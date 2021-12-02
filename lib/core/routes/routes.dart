import 'package:flutter/material.dart';
import 'package:intersmeet/ui/sign_in/sign_in_view.dart';
import 'package:intersmeet/ui/welcome/welcome_view.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    '/': (context) => const WelcomeView(),
    'sign-in': (context) => const SignInView(),
  };
}
