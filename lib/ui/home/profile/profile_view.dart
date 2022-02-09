import 'package:flutter/material.dart';
import 'package:intersmeet/core/constants/colorsz.dart';
import 'package:intersmeet/core/models/student/update_student.dart';
import 'package:intersmeet/core/models/user/update_user.dart';
import 'package:intersmeet/core/models/user/user.dart';
import 'package:intersmeet/core/models/user/user_utils.dart';
import 'package:intersmeet/core/services/authentication_service.dart';
import 'package:intersmeet/core/services/user_service.dart';
import 'package:intersmeet/main.dart';
import 'package:intersmeet/ui/home/home_scaffold.dart';
import 'package:intersmeet/ui/shared/br.dart';
import 'package:intersmeet/ui/shared/confirm_dialog.dart';
import 'package:intersmeet/ui/shared/gradient_button.dart';
import 'package:numberpicker/numberpicker.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  // @ Dependencies
  var userService = getIt<UserService>();
  var authService = getIt<AuthenticationService>();

  late User user;
  int applicationCount = 0;
  List<DropdownMenuItem<int>>? languages;
  List<DropdownMenuItem<int>>? provinces;
  List<DropdownMenuItem<int>>? degrees;

  // @ Form
  final _formKey = GlobalKey<FormState>();
  // @ Fields - Account
  final username = TextEditingController();
  String? _usernameError;
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
  void initState() {
    user = authService.getUser()!;
    asyncInitState();
    super.initState();
  }

  void asyncInitState() async {
    var count = await userService.applicationCount();
    var langs = await userService.findAllLanguages();
    var provs = await userService.findAllProvinces();
    var degrs = await userService.findAllDegrees();
    setState(() {
      languages = List.from(langs.map((lang) {
        return DropdownMenuItem(
            child: Text(lang.name, overflow: TextOverflow.ellipsis), value: lang.languageId);
      }));
      provinces = List.from(provs.map((pr) {
        return DropdownMenuItem(
          child: Text(pr.name, overflow: TextOverflow.ellipsis),
          value: pr.provinceId,
        );
      }));
      degrees = List.from(degrs.map((degree) {
        return DropdownMenuItem(
          child: Text(degree.name, overflow: TextOverflow.ellipsis),
          value: degree.degreeId,
        );
      }));
      applicationCount = count;
      patchForm();
    });
  }

  void patchForm() {
    // @ Fields - Account
    username.text = user.username;
    languageId = user.languageId;
    // @ Fields - Personal
    firstName.text = user.firstName;
    lastName.text = user.lastName;
    location.text = user.location;
    provinceId = user.provinceId;
    birthDate = DateTime.parse(user.birthDate);
    // @ Fields - Academic
    averageGrades = user.averageGrades;
    degreeId = user.degreeId;
  }

  @override
  Widget build(BuildContext context) {
    // @ Build UI
    return HomeScaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _header(flex: 1),
            br(10),
            _applicationsCard(),
            br(20),
            _form(),
            br(40),
            // Expanded(
            //   flex: 3,
            //   child: Container(
            //     color: Colors.transparent,
            //     child: Column(
            //       children: [
            //         br(20),
            //         Expanded(
            //           flex: 3,
            //           child: Container(
            //             margin: const EdgeInsets.only(left: 30, right: 30),
            //             child: Column(
            //               children: [
            //                 stepHeader(title: 'Account'),
            //                 const Divider(color: Colorz.accountPurple),
            //                 br(3)
            //               ],
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  Widget _form() {
    return Form(
      key: _formKey,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            _accountStep(),
            br(20),
            _personalStep(),
            br(20),
            _academicStep(),
            br(30),
            _submit(),
          ],
        ),
      ),
    );
  }

  Widget _submit() {
    return GradientButton(
      text: "Save changes",
      onPressed: () async {
        if (_formKey.currentState!.validate() && await _validateAccount()) {
          if (user.username != username.text) {
            showDialog(
              context: context,
              builder: (_context) => ConfirmDialog(
                title: "Save changes",
                content:
                    "You're about to update your username, if you do so, you will be redirectded to Sign-In Screen.",
                onAccept: () async {
                  await _update();
                  Navigator.of(context).pushNamedAndRemoveUntil('sign-in', (route) => false);
                },
              ),
            );
          } else {
            _update();
          }
        }
      },
      color1: const Color(0xff102836),
      color2: const Color(0xff03111a),
    );
  }

  Future<void> _update() async {
    if (await userService.updateProfile(
      UpdateStudent(
        birthDate: birthDate,
        degreeId: degreeId,
        averageGrades: averageGrades,
        updateUser: UpdateUser(
          firstName: firstName.text,
          languageId: languageId,
          lastName: lastName.text,
          location: location.text,
          provinceId: provinceId,
          username: username.text,
        ),
      ),
    )) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Changes saved successfully!'),
        ),
      );
    }
  }

  Widget _accountStep() {
    return Column(
      children: [
        _stepHeader(title: 'Account'),
        const Divider(color: Colorz.accountPurple),
        TextFormField(
          controller: username,
          decoration: InputDecoration(labelText: 'Username', errorText: _usernameError),
          validator: Validators.mixValidators([Validators.requiredd(), Validators.maxLength(40)]),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: DropdownButtonFormField(
            value: user.languageId,
            validator: (value) => value == null ? 'Language is required' : null,
            items: languages ?? <DropdownMenuItem<int>>[],
            decoration: const InputDecoration(labelText: 'Language'),
            hint: const Text('Language'),
            icon: const Icon(Icons.emoji_flags),
            onChanged: (value) {
              setState(() {
                if (value is int) languageId = value;
                // exception missing
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _personalStep() {
    return Column(
      children: [
        _stepHeader(title: 'Personal'),
        const Divider(color: Colorz.accountPurple),
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
            value: user.provinceId,
            items: provinces,
            validator: (value) => value == null ? 'Province is required' : null,
            decoration: const InputDecoration(labelText: 'Province'),
            hint: const Text('Province'),
            icon: const Icon(Icons.location_city),
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
          decoration: const InputDecoration(
            hintText: 'Location',
            labelText: 'Location',
          ),
          validator: Validators.requiredd(),
        ),
        br(15),
        Row(
          children: [
            Expanded(
              child: Text(
                '$birthDate'.split(' ')[0],
                textAlign: TextAlign.center,
              ),
            ),
            ElevatedButton(
              onPressed: _pickBirthdate,
              child: const Text('Birthdate'),
            )
          ],
        ),
      ],
    );
  }

  Widget _academicStep() {
    return Column(
      children: [
        _stepHeader(title: 'Academic'),
        const Divider(color: Colorz.accountPurple),
        const Text(
          "Average Grades",
          style: TextStyle(color: Color(0xFFbfbfbf), fontSize: 18),
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
            value: user.degreeId,
            items: degrees,
            validator: Validators.requiredd(),
            isExpanded: true,
            decoration: const InputDecoration(labelText: 'Degree'),
            hint: const Text('Degree'),
            icon: const Icon(Icons.school_outlined),
            onChanged: (value) {
              setState(() {
                if (value is int) degreeId = value;
                // exception missing
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _stepHeader({required String title}) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(fontSize: 28),
      ),
    );
  }

  Widget _header({required int flex}) {
    return SizedBox(
      height: 170,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  "assets/images/profile-bg.jpg",
                ),
                fit: BoxFit.fill,
              ),
            ),
          ),
          SizedBox(
            height: 150,
            width: 150,
            child: CircleAvatar(
              backgroundImage: user.getAvatar(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _applicationsCard() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * .8,
      child: Card(
        shadowColor: Colors.white,
        color: Colorz.richCalculatorInnerButtonColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: const Text(
                'Applications',
                style: TextStyle(fontSize: 34),
                textAlign: TextAlign.center,
              ),
              subtitle: Text(
                '$applicationCount',
                style: const TextStyle(fontSize: 30),
                textAlign: TextAlign.center,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Text('In progress'),
              ],
            ),
            br(10)
          ],
        ),
      ),
    );
  }

  Future<bool> _validateAccount() async {
    if (!await authService.checkUsername(username.text)) {
      setState(() {
        _usernameError = "Username not available, try another";
      });
      return false;
    }
    return true;
  }

  void _pickBirthdate() async {
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
}
