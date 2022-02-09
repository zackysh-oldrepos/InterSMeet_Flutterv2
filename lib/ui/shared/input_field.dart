import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String? label;
  final String? hint;
  final void Function(String value)? onChange;

  const InputField({Key? key, this.label, this.hint, this.onChange}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Container(
            margin: const EdgeInsets.only(
              bottom: 10,
            ),
            child: Text(
              label!,
              style:
                  const TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.w500),
            ),
          ),
        Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: TextField(
                style: TextStyle(color: Colors.grey[700]),
                onChanged: (value) {
                  if (onChange != null) onChange!(value);
                },
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: hint,
                    hintStyle: TextStyle(color: Colors.grey[800])),
              ),
            )),
      ],
    );
  }
}
