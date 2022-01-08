import 'package:flutter/material.dart';
import 'package:intersmeet/core/services/authentication_service.dart';
import 'package:intersmeet/core/services/user_service.dart';
import 'package:intersmeet/ui/shared/paint/bezier2_container.dart';
import 'package:intersmeet/ui/shared/spash_screen.dart';
import 'package:intersmeet/ui/welcome/tween_info_widget.dart';

import '../../main.dart';

class WelcomeView extends StatelessWidget {
  WelcomeView({Key? key}) : super(key: key);
  // @ Dependencies
  final userService = getIt<UserService>();
  final authService = getIt<AuthenticationService>();

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
    return FutureBuilder(
      future: Future.wait([authService.isSessionActive()]),
      builder: (_context, AsyncSnapshot<List<dynamic>> snapshot) {
        // splash screen
        if (!snapshot.hasData) return const Center(child: SpashScreen());

        // @ Load data
        if (snapshot.data != null) {
          // If session is active, navigate to home
          if (snapshot.data?[0] != null && snapshot.data?[0]) {
            WidgetsBinding.instance!.addPostFrameCallback((_) {
              Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false);
            });
            return const SizedBox();
          }
        }

        // -------------------------------------------------------------------------------
        // @ Build UI
        // -------------------------------------------------------------------------------
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Stack(
              children: [
                Positioned(
                    top: -height * .15,
                    right: -MediaQuery.of(context).size.width * .4,
                    child: const BezierContainer()),
                logo,
                Container(
                  margin: const EdgeInsets.only(top: 280, right: 5, left: 5),
                  child: const TweenWidget(),
                ),
                signInButton(context),
              ],
            ),
          ),
        );
      },
    );
  }

  Container signInButton(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      margin: const EdgeInsets.only(bottom: 20.0, left: 15, right: 15),
      child: ElevatedButton.icon(
        label: const Text(
          'Find your intership',
          style: TextStyle(fontSize: 20),
        ),
        icon: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.white,
          size: 24.0,
        ),
        onPressed: () {
          Navigator.pushNamed(context, '/auth-select');
        },
        style:
            ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(40), primary: Colors.black),
      ),
    );
  }

  Row infoWidget() {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20), topLeft: Radius.circular(20)),
              border: Border.all(color: Colors.black),
            ),
            padding: const EdgeInsets.only(bottom: 15),
            height: 160,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    flex: 3,
                    child: Container(
                      alignment: Alignment.center,
                      child: const Text(
                        "+3k Companies Offering Intership",
                        style: TextStyle(
                          fontSize: 24,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )),
                Expanded(
                    flex: 2,
                    child: Container(
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.badge_outlined,
                        color: Colors.black,
                        size: 54.0,
                      ),
                    )),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            padding: const EdgeInsets.only(bottom: 15),
            height: 160,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    flex: 3,
                    child: Container(
                      alignment: Alignment.center,
                      child: const Text(
                        "Quality tools to customize profile",
                        style: TextStyle(fontSize: 24, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    )),
                Expanded(
                    flex: 2,
                    child: Container(
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.dashboard,
                        color: Colors.white,
                        size: 54.0,
                      ),
                    )),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
