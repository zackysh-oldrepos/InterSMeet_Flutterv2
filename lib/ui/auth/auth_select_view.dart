import 'package:flutter/material.dart';
import 'package:intersmeet/ui/shared/expanded_button.dart';
import 'package:intersmeet/ui/shared/or_divider.dart';
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
                GradientButton(
                  onPressed: () => Navigator.pushNamed(context, "sign-in"),
                  text: "Sign In",
                  color2: const Color(0xff000000),
                  color1: const Color(0xff102836),
                ),
                const OrDivider(),
                GradientButton(
                  onPressed: () => Navigator.pushNamed(context, "sign-up"),
                  text: "Sign Up",
                  color1: const Color(0xff000101),
                  color2: const Color(0xff112836),
                ),
                const SizedBox(height: 60),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
