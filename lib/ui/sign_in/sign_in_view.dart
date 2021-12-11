import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:intersmeet/ui/shared/expanded_button.dart';
import 'package:intersmeet/ui/shared/input_field.dart';
import 'package:intersmeet/ui/shared/intersmeet_title.dart';
import 'package:intersmeet/ui/shared/or_divider.dart';
import 'package:intersmeet/ui/shared/paint/bezier2_container.dart';
import 'package:intersmeet/ui/shared/password_field.dart';
import 'package:intersmeet/ui/sign_up/sign_up_view.dart';

class SignInView extends StatefulWidget {
  const SignInView({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _SignInViewState createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
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

  Widget _emailAndPassword() {
    return Column(
      children: const [
        InputField(label: "Email or Username", hint: "user..."),
        SizedBox(height: 10),
        PasswordField(headerText: "Passowrd", hintTexti: "p@sW0Rd"),
      ],
    );
  }

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
                  SizedBox(height: height * .2),
                  const InterSMeetTitle(
                    fontSize: 30,
                    darkMode: false,
                  ),
                  const SizedBox(height: 50),
                  _emailAndPassword(),
                  const SizedBox(height: 20),
                  GradientButton(
                    text: "Sign In",
                    onPressed: () => {Navigator.pushNamed(context, "home")},
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
}
