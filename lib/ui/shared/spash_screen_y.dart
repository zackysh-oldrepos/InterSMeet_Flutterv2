import 'package:flutter/material.dart';

class SpashScreenWaves extends StatefulWidget {
  final Color color;
  const SpashScreenWaves({Key? key, required this.color}) : super(key: key);

  @override
  SpashScreenWavesState createState() => SpashScreenWavesState();
}

class SpashScreenWavesState extends State<SpashScreenWaves> with TickerProviderStateMixin {
  late double screenwidth;
  late double height;
  late Color color;
  late AnimationController animationController;
  late Animation animation;
  late Tween tween;

  @override
  void initState() {
    super.initState();
    color = widget.color;

    animationController = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    tween = Tween<double>(begin: 0.0, end: 1.0);
    animation = tween.animate(animationController);
    animation.addListener(() {
      setState(() {});
    });
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        animationController.forward();
      }
    });
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      child: initialize(),
      painter: SpashPainter(animation: animation, color: color, height: height, width: screenwidth),
    );
  }

  Widget initialize() {
    screenwidth = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Container();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}

class SpashPainter extends CustomPainter {
  final double height;
  final double width;
  final Animation animation;
  final Color color;

  SpashPainter(
      {required this.height, required this.width, required this.color, required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();
    path.moveTo(0, height - 100);
    path.lineTo(0, (height - 100) * 0.92);
    path.quadraticBezierTo(width * 0.25, (height - 100) - (1 - animation.value) * (width * 0.25),
        width * 0.5, (height - 100) * 0.92);
    path.quadraticBezierTo(width * 0.75, (height - 100) - animation.value * (width * 0.25), width,
        (height - 100) * 0.92);
    path.lineTo(width, (height - 100) - 100);
    var paint = Paint();
    paint.color = color;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
