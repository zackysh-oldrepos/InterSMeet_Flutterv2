import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intersmeet/core/models/language.dart';
import 'package:intersmeet/core/models/province.dart';
import 'package:intersmeet/ui/shared/expanded_button.dart';
import 'package:intersmeet/ui/shared/input_field.dart';
import 'package:intersmeet/ui/shared/intersmeet_title.dart';
import 'package:intersmeet/ui/shared/paint/bezier2_container.dart';
import 'package:intersmeet/ui/sign_in/sign_in_view.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  List<Province>? provinces;
  List<Language>? languages;
  int? languageId;
  int? provinceId;
  // form-validation
  AlertDialog? formAlert;
  Timer? _timer;
  bool _showAlert = false;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SizedBox(
        height: height,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: -MediaQuery.of(context).size.height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: const BezierContainer(),
            ),
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
                    const SizedBox(
                      height: 50,
                    ),
                    _form(),
                    const SizedBox(
                      height: 20,
                    ),
                    GradientButton(
                      text: "Sign Up Now",
                      // onPressed: () => {Navigator.pushNamed(context, "home")},
                      onPressed: () async {
                        if (validate()) {}
                      },
                      color1: const Color(0xff102836),
                      color2: const Color(0xff167363),
                    ),
                    SizedBox(height: height * .14),
                    _loginAccountLabel(),
                  ],
                ),
              ),
            ),
            Positioned(top: 40, left: 0, child: _backButton()),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------------------------------------------------------
  // @ Private functions
  // ----------------------------------------------------------------------------------------------------------

  /// Form validation
  bool validate() {
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

  Widget _loginAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const SignInView()));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        padding: const EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'Already have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Sign-In',
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

  Widget _form({required Function(String value) onCredentialChange}) {
    return Column(
      children: const <Widget>[
        InputField(hint: "Username"),
        SizedBox(height: 10),
        InputField(hint: "Email"),
        SizedBox(height: 10),
        InputField(hint: "First Name"),
        SizedBox(height: 10),
        InputField(hint: "Last Name"),
        SizedBox(height: 10),
        InputField(hint: "Address"),
        SizedBox(height: 10),
        InputField(hint: "Location"),
        SizedBox(height: 10),
        InputField(hint: "BirthDate"),
        SizedBox(height: 10),
        InputField(hint: "AverageGrades"),
        // DropdownButton<int>()
      ],
    );
  }
}
