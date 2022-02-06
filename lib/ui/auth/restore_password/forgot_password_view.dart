import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intersmeet/core/models/user/user_utils.dart';
import 'package:intersmeet/core/services/authentication_service.dart';
import 'package:intersmeet/core/services/user_service.dart';
import 'package:intersmeet/main.dart';
import 'package:intersmeet/ui/auth/restore_password/check_restore_password_view.dart';
import 'package:intersmeet/ui/shared/expanded_button.dart';
import 'package:intersmeet/ui/shared/paint/bezier2_container.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  _ForgotPasswordViewState createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  // @ Dependencies
  var userService = getIt<UserService>();
  var authService = getIt<AuthenticationService>();

  final _formKey = GlobalKey<FormState>();
  final credential = TextEditingController();
  String? _credential;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    // @ Build UI
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: -MediaQuery.of(context).size.height * .15,
            right: -MediaQuery.of(context).size.width * .4,
            child: const BezierContainer(),
          ),
          Container(
            padding: EdgeInsets.only(left: 80, top: height * .2),
            child: const Text(
              "Enter your email or username to restore your password",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w700,
                color: Color(0xFF00332d),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 300),
            padding: const EdgeInsets.only(left: 40, right: 40),
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 70),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                            controller: credential,
                            decoration: InputDecoration(
                                labelText: 'Credentials...', errorText: _credential),
                            validator: Validators.requiredd()),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 170),
                  child: GradientButton(
                    text: "Send",
                    onPressed: () async {
                      setState(() {
                        _credential = null;
                      });
                      if (_formKey.currentState!.validate()) {
                        // If user exists
                        if (!await authService.checkCredential(credential.text)) {
                          Navigator.of(context).pushNamed(
                            '/check-restore-password',
                            arguments: CheckRestorePasswordViewArguments(credential.text),
                          );
                        } else {
                          log('fail');
                          setState(() {
                            _credential = 'No account found with provided credentials';
                          });
                        }
                      }
                    },
                    color1: const Color(0xff102836),
                    color2: const Color(0xff03111a),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
