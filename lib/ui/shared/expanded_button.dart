import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExpandedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const ExpandedButton({Key? key, required this.text, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(vertical: 15),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.shade200,
                    offset: const Offset(2, 4),
                    blurRadius: 1,
                    spreadRadius: 2)
              ],
              gradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xFF2196F3), Color(0xFF00796B)])),
          child: Text(
            text,
            style: const TextStyle(fontSize: 20, color: Colors.white),
          )),
    );
  }
}
