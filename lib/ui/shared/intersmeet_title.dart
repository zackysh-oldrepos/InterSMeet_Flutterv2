import 'package:flutter/material.dart';

class InterSMeetTitle extends StatelessWidget {
  final bool darkMode;
  final double fontSize;

  const InterSMeetTitle({
    Key? key,
    this.darkMode = true,
    required this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'interS',
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
            color: darkMode ? const Color(0xFF00e6cb) : const Color(0xFF00695C),
          ),
          children: [
            TextSpan(
              text: 'Meet',
              style: TextStyle(
                  color: darkMode ? Colors.white : Colors.black,
                  fontSize: fontSize),
            ),
          ]),
    );
  }
}
