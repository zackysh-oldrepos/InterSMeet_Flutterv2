import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final Color color1;
  final Color color2;
  final VoidCallback onPressed;
  final bool disabled;

  const GradientButton({
    Key? key,
    required this.text,
    required this.color1,
    required this.color2,
    required this.onPressed,
    this.disabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 1,
            spreadRadius: 2,
          )
        ],
        gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [
          disabled ? _darken(color1, .1) : color1,
          disabled ? _darken(color2, .1) : color2,
        ]),
      ),
      child: SizedBox(
        child: ElevatedButton(
          onPressed: !disabled ? onPressed : null,
          child: Text(
            text,
            style: TextStyle(
              fontSize: 20,
              color: !disabled ? Colors.white : Colors.grey,
            ),
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.transparent),
          ),
        ),
      ),
    );
  }

  Color _darken(Color color, [double amount = .1]) {
    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }
}
