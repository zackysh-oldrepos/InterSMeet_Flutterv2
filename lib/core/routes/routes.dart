import 'package:flutter/material.dart';
import 'package:intersmeet/ui/auth/sign_in/sign_in_view.dart';
import 'package:intersmeet/ui/auth/sign_up/sign_up_view.dart';
import 'package:intersmeet/ui/home/home_view.dart';

import 'package:intersmeet/ui/auth/auth_select_view.dart';
import 'package:intersmeet/ui/welcome/welcome_view.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    '/': (context) => WelcomeView(),
    '/auth-select': (context) => const AuthSelectView(),
    'sign-in': (context) => const SignInView(),
    'sign-up': (context) => const SignUpView(),
    'home': (context) => const HomeView()
  };
}
