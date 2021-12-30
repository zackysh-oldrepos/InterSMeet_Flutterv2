import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onAccept;
  final VoidCallback? onCancel;

  const ConfirmDialog(
      {Key? key, required this.title, required this.content, required this.onAccept, this.onCancel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        ElevatedButton(
          child: const Text("Cancel"),
          onPressed: () {
            if (onCancel != null) onCancel!();
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: const Text("Ok"),
          onPressed: () {
            Navigator.of(context).pop();
            onAccept();
          },
        ),
      ],
    );
  }
}
