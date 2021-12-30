import 'package:flutter/material.dart';

class SplashScreenAccordion extends StatefulWidget {
  final Color color1, color2, color3, color4;
  final Offset pos;

  const SplashScreenAccordion({
    Key? key,
    required this.color1,
    required this.color2,
    required this.color3,
    required this.color4,
    required this.pos,
  }) : super(key: key);

  @override
  _SplashScreenAccordionState createState() => _SplashScreenAccordionState();
}

class _SplashScreenAccordionState extends State<SplashScreenAccordion>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation animation;
  late Tween tween;
  List<Color> colors = [];
  late Offset position;
  @override
  void initState() {
    super.initState();
    position = widget.pos;
    colors.add(widget.color1);
    colors.add(widget.color2);
    colors.add(widget.color3);
    colors.add(widget.color4);
    animationController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
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
      painter: SpashPainterX(animation: animation, colors: colors, position: position),
    );
  }

  @override
  void dispose() {
    animationController.stop();
    animationController.dispose();
    super.dispose();
  }
}

class SpashPainterX extends CustomPainter {
  late double animationtill1;
  late double animationtill2;
  double height = 30;
  final Animation animation;
  final Offset position;
  final List<Color> colors;

  SpashPainterX({required this.animation, required this.position, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < 4; i++) {
      height = 35;
      if (i == 0 || i == 3) {
        animationtill1 = (animation.value) * 35;
        animationtill2 = (animation.value) * 35;
      } else if (i == 1 || i == 2) {
        animationtill1 = (1.5 - animation.value) * 35;
        animationtill2 = (1.5 - animation.value) * 35;
      }

      var path = Path();
      var paint = Paint()..color = colors[i];
      path.moveTo(position.dx - 35 + 20 * i, position.dy - height + animationtill1);
      path.lineTo(position.dx - 25 + 20 * i, position.dy - height + animationtill2);
      path.lineTo(position.dx - 25 + 20 * i, position.dy + height - animationtill1);
      path.lineTo(position.dx - 35 + 20 * i, position.dy + height - animationtill2);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
