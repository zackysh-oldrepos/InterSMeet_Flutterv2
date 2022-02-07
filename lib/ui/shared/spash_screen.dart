import 'package:flutter/material.dart';
import 'package:intersmeet/ui/shared/spash_screen_x.dart';
import 'package:intersmeet/ui/shared/spash_screen_y.dart';

class SpashScreen extends StatelessWidget {
  const SpashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.grey[900],
        child: Column(
          children: [
            SplashScreenAccordion(
              color1: Colors.teal,
              color2: Colors.yellowAccent,
              color3: Colors.red,
              color4: Colors.black,
              pos: Offset(0, MediaQuery.of(context).size.height / 3),
            ),
            const SpashScreenWaves(color: Colors.teal)
          ],
        ),
      ),
    );
  }
}
