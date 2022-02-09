import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:intersmeet/core/exceptions/exception_handler.dart';
import 'package:intersmeet/core/exceptions/widget/exception_alert.dart';
import 'package:intersmeet/core/models/user/user_utils.dart';
import 'package:intersmeet/core/services/authentication_service.dart';
import 'package:intersmeet/ui/auth/sign_up/sign_up_view.dart';
import 'package:intersmeet/ui/shared/back_button.dart';
import 'package:intersmeet/ui/shared/br.dart';
import 'package:intersmeet/ui/shared/gradient_button.dart';
import 'package:intersmeet/ui/shared/intersmeet_title.dart';
import 'package:intersmeet/ui/shared/or_divider.dart';
import 'package:intersmeet/ui/shared/paint/bezier2_container.dart';

import '../../../main.dart';

class SignInView extends StatefulWidget {
  const SignInView({Key? key}) : super(key: key);

  @override
  _SignInViewState createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  // dependencies
  var authService = getIt<AuthenticationService>();
  var exceptionHandler = getIt<ExceptionHandler>();
  // form
  final _formKey = GlobalKey<FormState>();
  final credential = TextEditingController();
  String? _credentialError;
  final password = TextEditingController();
  String? _passwordError;
  bool _visible = false;
  bool rememberMe = false;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: SizedBox(
      height: height,
      child: Stack(
        children: <Widget>[
          Positioned(
              top: -height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: const BezierContainer()),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  br(height * .2),
                  // @ Unhandled exceptions ------------------------------
                  ExceptionAlertWidget(),
                  const InterSMeetTitle(
                    fontSize: 30,
                    darkMode: true,
                  ),
                  br(50),
                  // @ Form fields ------------------------------
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                            controller: credential,
                            decoration: InputDecoration(
                                labelText: 'Email or Username', errorText: _credentialError),
                            validator: Validators.mixValidators(
                                [Validators.requiredd(), Validators.maxLength(40)])),
                        TextFormField(
                          controller: password,
                          obscureText: !_visible,
                          validator: Validators.mixValidators([
                            Validators.requiredd(),
                            Validators.maxLength(40),
                          ]),
                          decoration: InputDecoration(
                              labelText: 'Password',
                              errorText: _passwordError,
                              suffixIcon: IconButton(
                                  icon: Icon(_visible ? Icons.visibility : Icons.visibility_off),
                                  onPressed: () {
                                    setState(() {
                                      _visible = !_visible;
                                    });
                                  })),
                        )
                      ],
                    ),
                  ),
                  br(20),
                  // @ Submit button ------------------------------
                  GradientButton(
                    text: "Sign In",
                    onPressed: () async {
                      setState(() {
                        _passwordError = null;
                        _credentialError = null;
                      });
                      if (_formKey.currentState!.validate()) {
                        int resStatus = await authService.signIn(
                          credential.text,
                          password.text,
                          rememberMe,
                        );
                        switch (resStatus) {
                          case 0:
                            var user = authService.getUser();
                            if (user?.emailVerified != true) {
                              Navigator.of(context).pushNamed('/email-verification');
                            } else {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                'home',
                                (Route<dynamic> route) => false,
                              );
                            }
                            break;
                          case 403: // user is a company
                            setState(() {
                              _credentialError = 'No account found with provided credentials';
                            });
                            break;
                          case 404: // user doesn't exists
                            setState(() {
                              _credentialError = 'No account found with provided credentials';
                            });
                            break;
                          case 401: // wrong password
                            setState(() {
                              _passwordError = 'Wrong password';
                            });
                            break;
                          // ignore: todo
                          // TODO if status == 500 use error handling
                        }
                      }
                    },
                    color1: const Color(0xff102836),
                    color2: const Color(0xff03111a),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text("Remember me"),
                        Checkbox(
                          value: rememberMe,
                          onChanged: (value) {
                            setState(() {
                              rememberMe = value ?? false;
                            });
                          },
                        )
                      ],
                    ),
                  ),
                  const OrDivider(),
                  SignInButton(
                    Buttons.Google,
                    onPressed: () {},
                  ),
                  br(height * .055),
                  _createAccountLabel(),
                  br(10),
                  _forgotPasswordLabel(),
                ],
              ),
            ),
          ),
          Positioned(top: 40, left: 0, child: backButton(context)),
        ],
      ),
    ));
  }

  // ----------------------------------------------------------------------------------------------------------
  // @ Widgets
  // ----------------------------------------------------------------------------------------------------------

  Widget _createAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpView()));
      },
      onFocusChange: (value) => {},
      child: Container(
        // margin: const EdgeInsets.symmetric(vertical: 20),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Don\'t have an account?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            br(10),
            const Text(
              'Sign Up',
              style: TextStyle(color: Color(0xFF00e6cb), fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _forgotPasswordLabel() {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed('/forgot-password');
      },
      onFocusChange: (value) => {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Forgot password?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            br(10),
            const Text(
              'Restore your password',
              style: TextStyle(color: Color(0xFF00e6cb), fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------------------------------------------------------
  // @ Life-cycle hook
  // ----------------------------------------------------------------------------------------------------------

  @override
  void dispose() {
    super.dispose();
  }
}
