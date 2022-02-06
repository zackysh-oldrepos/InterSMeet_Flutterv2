import 'package:flutter/material.dart';
import 'package:intersmeet/core/models/user/user_utils.dart';
import 'package:intersmeet/core/services/authentication_service.dart';
import 'package:intersmeet/core/services/user_service.dart';
import 'package:intersmeet/main.dart';
import 'package:intersmeet/ui/home/home_view.dart';
import 'package:intersmeet/ui/shared/expanded_button.dart';
import 'package:intersmeet/ui/shared/paint/bezier2_container.dart';

class EmailVerificationView extends StatefulWidget {
  const EmailVerificationView({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _EmailVerificationViewState createState() => _EmailVerificationViewState();
}

class _EmailVerificationViewState extends State<EmailVerificationView> {
  // @ Dependencies
  var userService = getIt<UserService>();
  var authService = getIt<AuthenticationService>();

  final _formKey = GlobalKey<FormState>();
  final verificationCode = TextEditingController();
  String? _verificationCodeError;

  @override
  void initState() {
    _awaitVerificationCode();
    super.initState();
  }

  void _awaitVerificationCode() async {
    var resStatus = await authService.sendEmailVerificationCode();

    switch (resStatus) {
      case 409:
        WidgetsBinding.instance!.addPostFrameCallback((_) {
          Navigator.of(context).pushNamedAndRemoveUntil('home', (Route<dynamic> route) => false,
              arguments: HomeViewArguments("Your email was already verified!"));
        });
        break;
    }
  }

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
              "We've sent an email verification code to your email address",
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
                            controller: verificationCode,
                            decoration: InputDecoration(
                                labelText: 'Enter your code here...',
                                errorText: _verificationCodeError),
                            validator: Validators.mixValidators([
                              Validators.requiredd(),
                              Validators.minLength(6),
                              Validators.maxLength(6),
                            ])),
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
                        _verificationCodeError = null;
                      });
                      if (_formKey.currentState!.validate()) {
                        var resStatus = await authService.emailVerification(verificationCode.text);
                        switch (resStatus) {
                          case 200:
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                'home', (Route<dynamic> route) => false,
                                arguments: HomeViewArguments("Email verified successfully!"));
                            break;
                          case 403:
                            _verificationCodeError = 'Wrong verification code';
                            break;
                        }
                      }
                    },
                    color1: const Color(0xff102836),
                    color2: const Color(0xff03111a),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 240),
                  child: _sendVerificationCodeLabel(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sendVerificationCodeLabel() {
    return InkWell(
      onTap: () async {
        int resStatus = await authService.sendEmailVerificationCode();
        switch (resStatus) {
          case 200:
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Verification code in the way!'),
              ),
            );
            break;
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          Text(
            'Don\'t have any code?',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            'Send new one',
            style: TextStyle(color: Color(0xFF00796B), fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
