import 'package:flutter/material.dart';
import 'package:intersmeet/ui/home/home_view.dart';
import 'package:intersmeet/ui/sign_in/sign_in_view.dart';
import 'package:intersmeet/ui/sign_up/sign_up_view.dart';
import 'package:intersmeet/ui/welcome/redirect/auth_select_view.dart';
import 'package:intersmeet/ui/welcome/welcome_view.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    '/': (context) => const WelcomeView(),
    '/auth-select': (context) => const AuthSelectView(),
    'sign-in': (context) => const SignInView(),
    'sign-up': (context) => const SignUpView(),
    'home': (context) => const HomeView()
  };
}
