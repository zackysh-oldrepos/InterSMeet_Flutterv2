import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final Color color1;
  final Color color2;
  final VoidCallback onPressed;

  const GradientButton(
      {Key? key,
      required this.text,
      required this.color1,
      required this.color2,
      required this.onPressed})
      : super(key: key);

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
        gradient: LinearGradient(
            begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [color1, color2]),
      ),
      child: SizedBox(
        child: ElevatedButton(
          onPressed: onPressed,
          child: Text(
            text,
            style: const TextStyle(fontSize: 20, color: Colors.white),
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.transparent),
          ),
        ),
      ),
    );
  }
}
