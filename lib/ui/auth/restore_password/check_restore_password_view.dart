import 'package:flutter/material.dart';
import 'package:intersmeet/core/models/user/user_utils.dart';
import 'package:intersmeet/core/services/authentication_service.dart';
import 'package:intersmeet/core/services/user_service.dart';
import 'package:intersmeet/main.dart';
import 'package:intersmeet/ui/auth/restore_password/restore_password_view.dart';
import 'package:intersmeet/ui/shared/expanded_button.dart';
import 'package:intersmeet/ui/shared/paint/bezier2_container.dart';

class CheckRestorePasswordViewArguments {
  final String? credential;

  CheckRestorePasswordViewArguments(this.credential);
}

class CheckRestorePasswordView extends StatefulWidget {
  const CheckRestorePasswordView({Key? key}) : super(key: key);

  @override
  _CheckRestorePasswordViewState createState() => _CheckRestorePasswordViewState();
}

class _CheckRestorePasswordViewState extends State<CheckRestorePasswordView> {
  // @ Dependencies
  var userService = getIt<UserService>();
  var authService = getIt<AuthenticationService>();
  CheckRestorePasswordViewArguments? args;

  final _formKey = GlobalKey<FormState>();
  final restorePasswordCode = TextEditingController();
  String? _restorePasswordCodeError;

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      // missing exception validate arguments
      args = ModalRoute.of(context)!.settings.arguments as CheckRestorePasswordViewArguments?;
      _awaitRestoreCode();
    });
    super.initState();
  }

  void _awaitRestoreCode() async {
    // ignore: unused_local_variable
    var resStatus = await authService.sendRestorePasswordCode(args!.credential!);
    // if (resStatus != 200) {} missing exception
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
              "We've sent a restore password code to your email address",
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
                            controller: restorePasswordCode,
                            decoration: InputDecoration(
                                labelText: 'Enter your code here...',
                                errorText: _restorePasswordCodeError),
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
                        _restorePasswordCodeError = null;
                      });
                      if (_formKey.currentState!.validate()) {
                        var resStatus = await authService.checkRestorePasswordCode(
                          args!.credential!,
                          restorePasswordCode.text,
                        );
                        switch (resStatus) {
                          case 200:
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              '/restore-password',
                              (Route<dynamic> route) => false,
                              arguments: RestorePasswordViewArguments(
                                args!.credential!,
                                restorePasswordCode.text,
                              ),
                            );
                            break;
                          case 403:
                            setState(() {
                              _restorePasswordCodeError = 'Wrong restore password code';
                            });
                            break;
                          // missing exception
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
        int resStatus = await authService.sendRestorePasswordCode(args!.credential!);
        if (resStatus == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Restore password code in the way!'),
            ),
          );
        } // exception missing
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
