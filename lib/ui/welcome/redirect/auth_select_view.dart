import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intersmeet/ui/shared/expanded_button.dart';
import 'package:intersmeet/ui/shared/paint/bezier2_container.dart';

class AuthSelectView extends StatelessWidget {
  const AuthSelectView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var logo = Container(
      alignment: Alignment.topCenter,
      margin: const EdgeInsets.only(top: 100),
      child: const Image(
        image: AssetImage('assets/images/logo/logo-black.png'),
        width: 350,
      ),
    );

    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: -height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: const BezierContainer(),
            ),
            logo,
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ExpandedButton(
                  onPressed: () => Navigator.pushNamed(context, "sign-in"),
                  text: "sign-in",
                ),
                const SizedBox(height: 20),
                ExpandedButton(
                  onPressed: () => Navigator.pushNamed(context, "sign-up"),
                  text: "sign-up",
                ),
                const SizedBox(height: 60),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Container button(BuildContext context) {
  //   return Container(
  //     width: MediaQuery.of(context).size.width,
  //     padding: const EdgeInsets.symmetric(vertical: 15),
  //     alignment: Alignment.center,
  //     decoration: BoxDecoration(
  //         borderRadius: const BorderRadius.all(Radius.circular(5)),
  //         boxShadow: <BoxShadow>[
  //           BoxShadow(
  //               color: Colors.grey.shade200,
  //               offset: const Offset(2, 4),
  //               blurRadius: 5,
  //               spreadRadius: 2)
  //         ],
  //         gradient: const LinearGradient(
  //             begin: Alignment.centerLeft,
  //             end: Alignment.centerRight,
  //             colors: [Color(0xFF2196F3), Color(0xFF00796B)])),
  //     child: const Text(
  //       'Sign-In',
  //       style: TextStyle(fontSize: 20, color: Colors.white),
  //     ),
  //   );
  // }
}
