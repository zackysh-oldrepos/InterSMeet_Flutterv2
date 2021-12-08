import 'dart:math';

import 'package:flutter/material.dart';

class TweenWidget extends StatefulWidget {
  const TweenWidget({Key? key}) : super(key: key);

  @override
  _TweenWidgetState createState() => _TweenWidgetState();
}

class _TweenWidgetState extends State<TweenWidget> {
  bool isBack = true;
  double angle = 0;

  void _flip() {
    setState(() {
      angle = (angle + pi) % (2 * pi);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background/bg-splash-0.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            GestureDetector(
              onTap: _flip,
              child: TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: angle),
                  duration: const Duration(seconds: 1),
                  builder: (BuildContext context, double val, __) {
                    if (val >= (pi / 2)) {
                      isBack = false;
                    } else {
                      isBack = true;
                    }
                    return (Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(val),
                      child: SizedBox(
                        width: 309,
                        height: 174,
                        child: isBack
                            ? Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: infoOneWidget(),
                              )
                            : Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.identity()..rotateY(pi),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: infoTwoWidget(),
                                ),
                              ),
                      ),
                    ));
                  }),
            )
          ]),
        ),
      ]),
    );
  }

  Expanded infoOneWidget() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
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
    );
  }

  Expanded infoTwoWidget() {
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.all(Radius.circular(20)),
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
    );
  }
}
