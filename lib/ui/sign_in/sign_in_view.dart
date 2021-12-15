import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:intersmeet/core/exceptions/variants/bad_request.dart';
import 'package:intersmeet/core/exceptions/widget/exception_alert.dart';
import 'package:intersmeet/core/exceptions/exception_handler.dart';
import 'package:intersmeet/core/models/user/user_utils.dart';
import 'package:intersmeet/core/services/authentication_service.dart';
import 'package:intersmeet/ui/shared/expanded_button.dart';
import 'package:intersmeet/ui/shared/input_field.dart';
import 'package:intersmeet/ui/shared/intersmeet_title.dart';
import 'package:intersmeet/ui/shared/or_divider.dart';
import 'package:intersmeet/ui/shared/paint/bezier2_container.dart';
import 'package:intersmeet/ui/shared/password_field.dart';
import 'package:intersmeet/ui/sign_up/sign_up_view.dart';

import '../../main.dart';

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
  String _credential = "";
  String _password = "";
  // form-validation
  AlertDialog? formAlert;
  Timer? _timer;
  bool _showAlert = false;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    // exception alert
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
                  SizedBox(height: height * .2),
                  // @ Unhandled exceptions ------------------------------
                  ExceptionAlertWidget(),
                  const InterSMeetTitle(
                    fontSize: 30,
                    darkMode: false,
                  ),
                  const SizedBox(height: 50),
                  // @ Form fields ------------------------------
                  _emailAndPassword(
                    onCredentialChange: (value) => _credential = value,
                    onPasswordChange: (value) => _password = value,
                  ),
                  const SizedBox(height: 20),
                  if (_showAlert) formAlert!,
                  if (_showAlert) const SizedBox(height: 20),
                  // @ Submit button ------------------------------
                  GradientButton(
                    text: "Sign In",
                    // onPressed: () => {Navigator.pushNamed(context, "home")},
                    onPressed: () async {
                      if (validate()) {
                        var res =
                            await authService.signIn(_credential, _password);
                        log("here bro");
                        log(res.runtimeType.toString());
                        if (res?.statusCode == 400) {
                          exceptionHandler.publishException(
                              BadRequestException(message: "Try again"));
                        }
                      }
                    },
                    color1: const Color(0xff102836),
                    color2: const Color(0xff03111a),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.centerRight,
                    child: const Text('Forgot Password ?',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500)),
                  ),
                  const OrDivider(),
                  SignInButton(
                    Buttons.Google,
                    onPressed: () {},
                  ),
                  SizedBox(height: height * .055),
                  _createAccountLabel(),
                ],
              ),
            ),
          ),
          Positioned(top: 40, left: 0, child: _backButton()),
        ],
      ),
    ));
  }

  // ----------------------------------------------------------------------------------------------------------
  // @ Private functions
  // ----------------------------------------------------------------------------------------------------------

  /// Validate form
  bool validate() {
    if (_credential.contains('@') && !isEmail(_credential)) {
      log("alert");
      showFormAlert("Email isn't valid");
      return false;
    } else if (_credential.isEmpty || _password.isEmpty) {
      showFormAlert("Please, fill all fields");
      return false;
    }
    return true;
  }

  /// Change form alert and show it foor 10 seconds
  void showFormAlert(String text) {
    formAlert = AlertDialog(
      content: Text(text),
      backgroundColor: const Color(0xff17182b),
      insetPadding: const EdgeInsets.all(0),
      contentPadding: const EdgeInsets.all(10),
      actionsPadding: const EdgeInsets.all(0),
      contentTextStyle: const TextStyle(color: Color(0xffde6f76)),
    );

    setState(() {
      _showAlert = true;
    });

    _timer = Timer(const Duration(milliseconds: 10000), () {
      setState(() {
        _showAlert = false;
      });
    });
  }

  // ----------------------------------------------------------------------------------------------------------
  // @ Widgets
  // ----------------------------------------------------------------------------------------------------------

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: const Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            const Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget _createAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const SignUpView()));
      },
      onFocusChange: (value) => {},
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        padding: const EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'Don\'t have an account?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Sign Up',
              style: TextStyle(
                  color: Color(0xFF00796B),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emailAndPassword(
      {required void Function(String value) onCredentialChange,
      required void Function(String value) onPasswordChange}) {
    return Column(
      children: [
        InputField(
          label: "Email or Username",
          hint: "user...",
          onChange: (value) => onCredentialChange(value),
        ),
        const SizedBox(height: 10),
        PasswordField(
          headerText: "Passowrd",
          hintTexti: "p@sW0Rd",
          onChange: (value) => onPasswordChange(value),
        ),
      ],
    );
  }

  // ----------------------------------------------------------------------------------------------------------
  // @ Life-cycle hook
  // ----------------------------------------------------------------------------------------------------------

  @override
  void dispose() {
    super.dispose();
    _timer!.cancel();
  }
}
