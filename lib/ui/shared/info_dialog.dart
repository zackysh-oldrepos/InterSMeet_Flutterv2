import 'package:flutter/material.dart';

class InfoDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onAccept;

  const InfoDialog({Key? key, required this.title, required this.content, required this.onAccept})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        ElevatedButton(
          child: const Text("Ok"),
          onPressed: () {
            Navigator.pop(context, true);
            onAccept();
          },
        ),
      ],
    );
  }
}
