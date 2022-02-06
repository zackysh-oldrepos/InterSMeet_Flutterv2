import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:intersmeet/core/models/degree.dart';
import 'package:intersmeet/core/models/language.dart';
import 'package:intersmeet/core/models/province.dart';
import 'package:intersmeet/core/models/user/student_sign_up.dart';
import 'package:intersmeet/core/models/user/user_sign_up.dart';
import 'package:intersmeet/core/models/user/user_utils.dart';
import 'package:intersmeet/core/services/authentication_service.dart';
import 'package:intersmeet/core/services/user_service.dart';
import 'package:intersmeet/main.dart';
import 'package:intersmeet/ui/shared/confirm_dialog.dart';
import 'package:intersmeet/ui/shared/intersmeet_title.dart';
import 'package:intersmeet/ui/shared/paint/bezier2_container.dart';
import 'package:intersmeet/ui/shared/spash_screen.dart';
import 'package:numberpicker/numberpicker.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  // @ Dependencies
  var userService = getIt<UserService>();
  var authService = getIt<AuthenticationService>();
  // @ Data
  late List<DropdownMenuItem<int>> provinces;
  late List<DropdownMenuItem<int>> languages;
  late List<DropdownMenuItem<int>> degrees;
  // @ Stepper
  int _currentStep = 0;
  // @ Forms
  final _accountFormKey = GlobalKey<FormState>();
  final _accountStep = 0;
  final _personalFormKey = GlobalKey<FormState>();
  final _personalStep = 1;
  final _academicFormKey = GlobalKey<FormState>();
  final _academicStep = 2;
  // @ Fields - Account
  bool _isObscure = true;
  final username = TextEditingController();
  String? _usernameError;
  final email = TextEditingController();
  String? _emailError;
  final password = TextEditingController();
  late int languageId;
  // @ Fields - Personal
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final location = TextEditingController();
  late int provinceId;
  DateTime birthDate = DateTime(DateTime.now().year - 17);
  // @ Fields - Academic
  late int averageGrades = 5;
  late int degreeId;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return FutureBuilder(
        future: Future.wait([
          userService.findAllProvinces(),
          userService.findAllLanguages(),
          userService.findAllDegrees()
        ]),
        builder: (_context, AsyncSnapshot<List<dynamic>> snapshot) {
          // splash screen
          if (!snapshot.hasData) return const Center(child: SpashScreen());

          // @ Load data
          if (snapshot.data != null &&
              snapshot.data![0] is List<Province> &&
              snapshot.data![1] is List<Language> &&
              snapshot.data![2] is List<Degree>) {
            // if all data is right map provinces, languages & degrees to dropdown items
            var p = snapshot.data![0] as List<Province>;
            provinces = List.from(p.map((pr) {
              return DropdownMenuItem(
                child: Text(pr.name, overflow: TextOverflow.ellipsis),
                value: pr.provinceId,
              );
            }));

            var l = snapshot.data![1] as List<Language>;
            languages = List.from(l.map((lang) {
              return DropdownMenuItem(
                  child: Text(lang.name, overflow: TextOverflow.ellipsis), value: lang.languageId);
            }));

            var d = snapshot.data![2] as List<Degree>;
            degrees = List.from(d.map((degree) {
              return DropdownMenuItem(
                child: Text(degree.name, overflow: TextOverflow.ellipsis),
                value: degree.degreeId,
              );
            }));
          } // exception missing
          // @ Build UI
          return Scaffold(
            body: SizedBox(
              height: height,
              width: width,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: -MediaQuery.of(_context).size.height * .15,
                    right: -MediaQuery.of(_context).size.width * .4,
                    child: const BezierContainer(),
                  ),
                  SizedBox(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 80, top: height * .2),
                            child: const InterSMeetTitle(
                              fontSize: 30,
                              darkMode: false,
                            ),
                          ),
                          Center(
                            child: Container(
                              margin: const EdgeInsets.only(top: 20),
                              child: Stepper(
                                currentStep: _currentStep,
                                onStepCancel: () {
                                  if (_currentStep > 0) {
                                    setState(() {
                                      _currentStep -= 1;
                                    });
                                  }
                                },
                                onStepContinue: () async {
                                  // -------------------------------------------------------
                                  // @ Form Validation & Submit
                                  // -------------------------------------------------------

                                  setState(() {
                                    // clear existing async-validation errors
                                    _usernameError = null;
                                    _emailError = null;
                                  });

                                  if (_currentStep == _accountStep) {
                                    // @ Account Step Validation
                                    if (_accountFormKey.currentState!.validate() &&
                                        await validateAccount()) {
                                      setState(() {
                                        _currentStep += 1;
                                      });
                                    }
                                  } else if (_currentStep == _personalStep) {
                                    // trigger InputDatePickerFormField onDateSaved
                                    _personalFormKey.currentState!.save();
                                    // @ Personal Step Validation
                                    if (_personalFormKey.currentState!.validate()) {
                                      setState(() {
                                        _currentStep += 1;
                                      });
                                    }
                                  } else if (_currentStep == _academicStep) {
                                    // @ Submit & Global validation
                                    // ignore: todo
                                    // TODO perform manual validation or show generic alert
                                    // if sign-up post fails
                                    if (_accountFormKey.currentState!.validate() &&
                                        _academicFormKey.currentState!.validate() &&
                                        _personalFormKey.currentState!.validate()) {
                                      showDialog(
                                        context: _context,
                                        builder: (__context) => ConfirmDialog(
                                          title: "Submit",
                                          content:
                                              "Do you want to create your account with this information?",
                                          onAccept: () async {
                                            if (await authService.signUp(
                                              StudentSignUp(
                                                averageGrades: averageGrades.toDouble(),
                                                degreeId: degreeId,
                                                birthDate: birthDate,
                                                userSignUp: UserSignUp(
                                                    username: username.text,
                                                    email: email.text,
                                                    firstName: firstName.text,
                                                    lastName: lastName.text,
                                                    provinceId: provinceId,
                                                    location: location.text,
                                                    password: password.text,
                                                    languageId: languageId),
                                              ),
                                            )) {
                                              Navigator.of(context).pushNamedAndRemoveUntil(
                                                  '/email-verification',
                                                  (Route<dynamic> route) => false);
                                            } else {
                                              // missing exception
                                              log("failed sign-up");
                                            }
                                          },
                                        ),
                                      );
                                    }
                                  }
                                },
                                onStepTapped: (int index) {
                                  setState(() {
                                    _currentStep = index;
                                  });
                                },
                                steps: stepList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  List<Step> stepList() => [
        Step(
          // @ Account Step
          state: _currentStep <= _accountStep || !_accountFormKey.currentState!.validate()
              ? StepState.editing
              : StepState.complete,
          title: const Text('Account'),
          content: Container(
            alignment: Alignment.centerLeft,
            child: Focus(
              child: Form(
                key: _accountFormKey,
                child: Column(
                  children: [
                    TextFormField(
                        controller: username,
                        decoration:
                            InputDecoration(labelText: 'Username', errorText: _usernameError),
                        validator: Validators.mixValidators(
                            [Validators.requiredd(), Validators.maxLength(40)])),
                    TextFormField(
                      controller: email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(labelText: 'Email', errorText: _emailError),
                      validator:
                          Validators.mixValidators([Validators.requiredd(), Validators.email()]),
                    ),
                    TextFormField(
                      obscureText: _isObscure,
                      controller: password,
                      validator: Validators.mixValidators(
                          [Validators.requiredd(), Validators.minLength(6)]),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscure ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: DropdownButtonFormField(
                        icon: const Icon(Icons.emoji_flags),
                        validator: (value) => value == null ? 'Language is required' : null,
                        hint: const Text('Language'),
                        items: languages,
                        onChanged: (value) {
                          setState(() {
                            if (value is int) languageId = value;
                            // exception missing
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Step(
          // @ Personal Step
          state: _currentStep <= _personalStep || !_personalFormKey.currentState!.validate()
              ? StepState.editing
              : StepState.complete,
          title: const Text('Personal'),
          content: Container(
            alignment: Alignment.centerLeft,
            child: Focus(
              child: Form(
                key: _personalFormKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: firstName,
                      decoration: const InputDecoration(labelText: 'First Name'),
                      validator: Validators.requiredd(),
                    ),
                    TextFormField(
                      controller: lastName,
                      decoration: const InputDecoration(labelText: 'Last Name'),
                      validator: Validators.requiredd(),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: DropdownButtonFormField(
                        icon: const Icon(Icons.location_city),
                        validator: (value) => value == null ? 'Province is required' : null,
                        hint: const Text('Province'),
                        items: provinces,
                        onChanged: (value) {
                          setState(() {
                            if (value is int) provinceId = value;
                            // exception missing
                          });
                        },
                      ),
                    ),
                    TextFormField(
                      controller: location,
                      decoration: const InputDecoration(hintText: 'Location'),
                      validator: Validators.requiredd(),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '$birthDate'.split(' ')[0],
                            textAlign: TextAlign.center,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: pickBirthdate,
                          child: const Text('Birthdate'),
                        )
                      ],
                    ),
                    const Divider(
                      height: 2,
                      color: Colors.grey,
                      thickness: 1,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        Step(
          // @ Academic Step
          state: _currentStep <= _academicStep || !_academicFormKey.currentState!.validate()
              ? StepState.editing
              : StepState.complete,
          title: const Text('Academic'),
          content: Container(
            alignment: Alignment.centerLeft,
            child: Focus(
              child: Form(
                key: _academicFormKey,
                child: Column(
                  children: [
                    const Text(
                      "Average Grades",
                      style: TextStyle(color: Color(0xff616161), fontSize: 18),
                    ),
                    NumberPicker(
                      value: averageGrades,
                      minValue: 0,
                      maxValue: 10,
                      axis: Axis.horizontal,
                      onChanged: (value) => setState(() => averageGrades = value),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: DropdownButtonFormField(
                        isExpanded: true,
                        icon: const Icon(Icons.school_outlined),
                        validator: Validators.requiredd(),
                        hint: const Text('Degree'),
                        items: degrees,
                        onChanged: (value) {
                          setState(() {
                            if (value is int) degreeId = value;
                            // exception missing
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ];

  Future<bool> validateAccount() async {
    if (!await authService.checkUsername(username.text)) {
      setState(() {
        _usernameError = "Username not available, try another";
      });
      return false;
    }
    if (!await authService.checkEmail(email.text)) {
      setState(() {
        _emailError = "Email not available, try another";
      });
      return false;
    }
    return true;
  }

  void pickBirthdate() async {
    final DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: birthDate,
      firstDate: DateTime(1950),
      lastDate: DateTime(DateTime.now().year - 16),
    );
    if (newDate != null) {
      setState(() {
        birthDate = newDate;
      });
    }
  }

  @override
  void dispose() {
    username.dispose();
    firstName.dispose();
    lastName.dispose();
    super.dispose();
  }
}
