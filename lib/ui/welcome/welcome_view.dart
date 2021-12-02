import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var logo = Container(
      alignment: Alignment.topCenter,
      margin: const EdgeInsets.only(top: 100),
      child: const Image(
        image: AssetImage('assets/logo-white.png'),
        width: 350,
      ),
    );

    var nextButton = Container(
      alignment: Alignment.bottomCenter,
      margin: const EdgeInsets.only(bottom: 20.0, left: 15, right: 15),
      child: ElevatedButton.icon(
        label: const Text(
          'Launch screen',
          style: TextStyle(fontSize: 20),
        ),
        icon: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.white,
          size: 24.0,
        ),
        onPressed: () {
          Navigator.pushNamed(context, 'sign-in');
        },
        style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(40), primary: Colors.black),
      ),
    );

    return Scaffold(
        backgroundColor: Colors.blue,
        body: SafeArea(
          child: Stack(
            children: [
              logo,
              Container(
                margin: const EdgeInsets.only(top: 350, right: 5, left: 5),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              topLeft: Radius.circular(20)),
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
                              bottomRight: Radius.circular(20),
                              topRight: Radius.circular(20)),
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
                                        fontSize: 24, color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                )),
                            Expanded(
                                flex: 2,
                                child: Container(
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons.badge_outlined,
                                    color: Colors.white,
                                    size: 54.0,
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              nextButton,
            ],
          ),
        ));
  }
}

/*



*/
