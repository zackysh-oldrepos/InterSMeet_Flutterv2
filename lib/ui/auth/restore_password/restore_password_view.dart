import 'package:flutter/material.dart';
import 'package:intersmeet/core/models/user/user_utils.dart';
import 'package:intersmeet/core/services/authentication_service.dart';
import 'package:intersmeet/core/services/user_service.dart';
import 'package:intersmeet/main.dart';
import 'package:intersmeet/ui/shared/expanded_button.dart';
import 'package:intersmeet/ui/shared/info_dialog.dart';
import 'package:intersmeet/ui/shared/paint/bezier2_container.dart';

class RestorePasswordViewArguments {
  final String? credential;
  final String? restorePasswordCode;

  RestorePasswordViewArguments(this.credential, this.restorePasswordCode);
}

class RestorePasswordView extends StatefulWidget {
  const RestorePasswordView({Key? key}) : super(key: key);

  @override
  _RestorePasswordViewState createState() => _RestorePasswordViewState();
}

class _RestorePasswordViewState extends State<RestorePasswordView> {
  // @ Dependencies
  var userService = getIt<UserService>();
  var authService = getIt<AuthenticationService>();

  final _formKey = GlobalKey<FormState>();
  final newPassword = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      // missing exception validate arguments
      _awaitRestoreCode();
    });
    super.initState();
  }

  void _awaitRestoreCode() async {
    final args = ModalRoute.of(context)!.settings.arguments as RestorePasswordViewArguments;
    // ignore: unused_local_variable
    var resStatus =
        await authService.sendRestorePasswordCode(args.credential!); // missing exception
    // if (resStatus != 200) {} missing exception
  }

  @override
  Widget build(BuildContext context) {
    // @ Build UI
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: -MediaQuery.of(context).size.height * .15,
            right: -MediaQuery.of(context).size.width * .4,
            child: const BezierContainer(),
          ),
          const Center(
            heightFactor: 17,
            child: Text(
              "Enter your new password",
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
                            controller: newPassword,
                            decoration: const InputDecoration(labelText: 'New Password...'),
                            validator: Validators.mixValidators([
                              Validators.requiredd(),
                              Validators.minLength(6),
                              Validators.maxLength(40)
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
                      if (_formKey.currentState!.validate()) {
                        // missing exception validate arguments
                        final RestorePasswordViewArguments args = ModalRoute.of(context)!
                            .settings
                            .arguments as RestorePasswordViewArguments;
                        var resStatus = await authService.restorePassword(
                          args.credential!,
                          newPassword.text,
                          args.restorePasswordCode!,
                        );

                        if (resStatus == 200) {
                          showDialog(
                            context: context,
                            builder: (__context) => InfoDialog(
                              title: "Success!",
                              content: "You have restored your password, sign-in again",
                              onAccept: () async {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  'sign-in',
                                  (Route<dynamic> route) => false,
                                );
                              },
                            ),
                          ).then((value) {
                            if (value == null) {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                'sign-in',
                                (Route<dynamic> route) => false,
                              );
                            }
                          });
                        } // missing exception
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
