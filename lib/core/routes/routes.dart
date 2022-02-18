import 'package:flutter/material.dart';
import 'package:intersmeet/ui/auth/email_verification/email_verification_view.dart';
import 'package:intersmeet/ui/auth/restore_password/check_restore_password_view.dart';
import 'package:intersmeet/ui/auth/restore_password/forgot_password_view.dart';
import 'package:intersmeet/ui/auth/restore_password/restore_password_view.dart';
import 'package:intersmeet/ui/auth/sign_in/sign_in_view.dart';
import 'package:intersmeet/ui/auth/sign_up/sign_up_view.dart';
import 'package:intersmeet/ui/home/applications/applications_view.dart';
import 'package:intersmeet/ui/home/home_view.dart';

import 'package:intersmeet/ui/auth/auth_select_view.dart';
import 'package:intersmeet/ui/home/offers/offers_view.dart';
import 'package:intersmeet/ui/home/profile/profile_view.dart';
import 'package:intersmeet/ui/welcome/welcome_view.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    // @ Authorized
    'home': (context) => const HomeView(),
    'profile': (context) => const ProfileView(),
    'offers': (context) => const OffersView(),
    'applications': (context) => const ApplicationsView(),
    // @ Auth
    '/auth-select': (context) => const AuthSelectView(),
    'sign-in': (context) => const SignInView(),
    'sign-up': (context) => const SignUpView(),
    '/check-restore-password': (context) => const CheckRestorePasswordView(),
    '/email-verification': (context) => const EmailVerificationView(),
    '/forgot-password': (context) => const ForgotPasswordView(),
    '/restore-password': (context) => const RestorePasswordView(),
    // @ Unauthorized
    '/welcome': (context) => WelcomeView(),
  };
}
