import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:intersmeet/core/models/user/user_utils.dart';
import 'package:intersmeet/core/services/authentication_service.dart';
import 'package:intersmeet/main.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _type = StepperType.vertical;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WizardFormBloc(),
      child: Builder(
        builder: (context) {
          return Theme(
            data: Theme.of(context).copyWith(
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                title: const Text('Sign Up'),
                // actions: <Widget>[
                //   IconButton(
                //       icon: Icon(_type == StepperType.horizontal
                //           ? Icons.swap_vert
                //           : Icons.swap_horiz),
                //       onPressed: Theme.of(context).appBarTheme = )
                // ],
              ),
              body: SafeArea(
                child: FormBlocListener<WizardFormBloc, String, String>(
                  onSubmitting: (context, state) => LoadingDialog.show(context),
                  onSuccess: (context, state) {
                    LoadingDialog.hide(context);

                    if (state.stepCompleted == state.lastStep) {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (_) => const SuccessScreen()));
                    }
                  },
                  onFailure: (context, state) {
                    LoadingDialog.hide(context);
                  },
                  child: StepperFormBlocBuilder<WizardFormBloc>(
                    formBloc: context.read<WizardFormBloc>(),
                    type: _type,
                    physics: const ClampingScrollPhysics(),
                    stepsBuilder: (formBloc) {
                      return [
                        _accountStep(formBloc!),
                        _personalStep(formBloc),
                        _academicStep(formBloc),
                      ];
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   final height = MediaQuery.of(context).size.height;
  //   final width = MediaQuery.of(context).size.width;

  //   return Scaffold(
  //     body: SizedBox(
  //       height: height,
  //       width: width,
  //       child: Stack(
  //         children: <Widget>[
  //           Positioned(
  //             top: -MediaQuery.of(context).size.height * .15,
  //             right: -MediaQuery.of(context).size.width * .4,
  //             child: const BezierContainer(),
  //           ),
  //           SizedBox(
  //             child: SingleChildScrollView(
  //               child: Column(
  //                 children: [
  //                   Container(
  //                     color: Colors.amber,
  //                     padding: EdgeInsets.only(left: 80, top: height * .2),
  //                     child: const InterSMeetTitle(
  //                       fontSize: 30,
  //                       darkMode: false,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //           Positioned(top: 40, left: 0, child: _backButton()),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // ----------------------------------------------------------------------------------------------------------
  // @ Widgets
  // ----------------------------------------------------------------------------------------------------------const

  FormBlocStep _accountStep(WizardFormBloc wizardFormBloc) {
    return FormBlocStep(
      title: const Text('Account'),
      content: Column(
        children: <Widget>[
          TextFieldBlocBuilder(
            textFieldBloc: wizardFormBloc.username,
            keyboardType: TextInputType.emailAddress,
            enableOnlyWhenFormBlocCanSubmit: true,
            decoration: const InputDecoration(
              labelText: 'Username',
              prefixIcon: Icon(Icons.person),
            ),
          ),
          TextFieldBlocBuilder(
            textFieldBloc: wizardFormBloc.email,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email),
            ),
          ),
          TextFieldBlocBuilder(
            textFieldBloc: wizardFormBloc.password,
            keyboardType: TextInputType.emailAddress,
            suffixButton: SuffixButton.obscureText,
            decoration: const InputDecoration(
              labelText: 'Password',
              prefixIcon: Icon(Icons.lock),
            ),
          ),
        ],
      ),
    );
  }

  FormBlocStep _personalStep(WizardFormBloc wizardFormBloc) {
    return FormBlocStep(
      title: const Text('Personal'),
      content: Column(
        children: <Widget>[
          TextFieldBlocBuilder(
            textFieldBloc: wizardFormBloc.firstName,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'First Name',
              prefixIcon: Icon(Icons.person),
            ),
          ),
          TextFieldBlocBuilder(
            textFieldBloc: wizardFormBloc.lastName,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Last Name',
              prefixIcon: Icon(Icons.person),
            ),
          ),
          RadioButtonGroupFieldBlocBuilder<String>(
            selectFieldBloc: wizardFormBloc.gender,
            itemBuilder: (context, value) => FieldItem(
              child: Text(value),
            ),
            decoration: const InputDecoration(
              labelText: 'Gender',
              prefixIcon: SizedBox(),
            ),
          ),
          DateTimeFieldBlocBuilder(
            dateTimeFieldBloc: wizardFormBloc.birthDate,
            firstDate: DateTime(1900),
            initialDate: DateTime.now(),
            lastDate: DateTime.now(),
            format: DateFormat('yyyy-MM-dd'),
            decoration: const InputDecoration(
              labelText: 'Date of Birth',
              prefixIcon: Icon(Icons.cake),
            ),
          ),
        ],
      ),
    );
  }

  FormBlocStep _academicStep(WizardFormBloc wizardFormBloc) {
    return FormBlocStep(
      title: const Text('Academic'),
      content: Column(
        children: <Widget>[
          TextFieldBlocBuilder(
            textFieldBloc: wizardFormBloc.github,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Github',
              prefixIcon: Icon(Icons.sentiment_satisfied),
            ),
          ),
          TextFieldBlocBuilder(
            textFieldBloc: wizardFormBloc.twitter,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Twitter',
              prefixIcon: Icon(Icons.sentiment_satisfied),
            ),
          ),
          TextFieldBlocBuilder(
            textFieldBloc: wizardFormBloc.facebook,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Facebook',
              prefixIcon: Icon(Icons.sentiment_satisfied),
            ),
          ),
        ],
      ),
    );
  }
}

class WizardFormBloc extends FormBloc<String, String> {
  var authService = getIt<AuthenticationService>();

  final username = TextFieldBloc(
    validators: [FieldBlocValidators.required, CustomValidators.maxLength(40)],
  );

  final email = TextFieldBloc<String>(
    validators: [
      FieldBlocValidators.required,
      FieldBlocValidators.email,
      CustomValidators.maxLength(100)
    ],
  );

  final password = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
      FieldBlocValidators.passwordMin6Chars,
    ],
  );

  final firstName = TextFieldBloc();

  final lastName = TextFieldBloc();

  final gender = SelectFieldBloc(
    items: ['Male', 'Female'],
  );

  final birthDate = InputFieldBloc<DateTime?, Object>(
    initialValue: null,
    validators: [FieldBlocValidators.required],
  );

  final github = TextFieldBloc();

  final twitter = TextFieldBloc();

  final facebook = TextFieldBloc();

  WizardFormBloc() {
    addFieldBlocs(
      step: 0,
      fieldBlocs: [username, email, password],
    );
    addFieldBlocs(
      step: 1,
      fieldBlocs: [firstName, lastName, gender, birthDate],
    );
    addFieldBlocs(
      step: 2,
      fieldBlocs: [github, twitter, facebook],
    );
  }

  @override
  void onSubmitting() async {
    if (state.currentStep == 0) {
      // check if username or email is taken
      var usrRes = await authService.checkUsername(username.value);
      var emlRes = await authService.checkEmail(email.value);
      if (usrRes?.statusCode == 409) {
        username.addFieldError('That username is already taken');
      }
      if (emlRes?.statusCode == 409) {
        email.addFieldError('That email is already taken');
      }
      if (usrRes?.statusCode == 409 || emlRes?.statusCode == 409) {
        emitFailure();
      } else {
        emitSuccess();
      }
    } else if (state.currentStep == 1) {
      emitSuccess();
    } else if (state.currentStep == 2) {
      await Future.delayed(const Duration(milliseconds: 500));
      emitSuccess();
    }
  }
}

class LoadingDialog extends StatelessWidget {
  static void show(BuildContext context, {Key? key}) => showDialog<void>(
        context: context,
        useRootNavigator: false,
        barrierDismissible: false,
        builder: (_) => LoadingDialog(key: key),
      ).then((_) => FocusScope.of(context).requestFocus(FocusNode()));

  static void hide(BuildContext context) => Navigator.pop(context);

  const LoadingDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Center(
        child: Card(
          child: Container(
            width: 80,
            height: 80,
            padding: const EdgeInsets.all(12.0),
            child: const CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(Icons.tag_faces, size: 100),
            const SizedBox(height: 10),
            const Text(
              'Success',
              style: TextStyle(fontSize: 54, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const SignUpView())),
              icon: const Icon(Icons.replay),
              label: const Text('AGAIN'),
            ),
          ],
        ),
      ),
    );
  }
}
