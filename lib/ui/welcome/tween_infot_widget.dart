import 'dart:math';

import 'package:flutter/material.dart';

class TweentWidget extends StatefulWidget {
  const TweentWidget({Key? key}) : super(key: key);

  @override
  _TweentWidgetState createState() => _TweentWidgetState();
}

class _TweentWidgetState extends State<TweentWidget> {
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
      backgroundColor: const Color(0xFF292a3e),
      body: SafeArea(
        child: Center(
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
                        height: 474,
                        child: isBack
                            ? Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  image: const DecorationImage(
                                    image: AssetImage("assets/images/background/back.png"),
                                  ),
                                ),
                              )
                            : Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.identity()..rotateY(pi),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    image: const DecorationImage(
                                      image: AssetImage("assets/images/background/face.png"),
                                    ),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "Surprise ! 🎊",
                                      style: TextStyle(
                                        fontSize: 30.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ));
                  }),
            )
          ]),
        ),
      ),
    );
  }
}
