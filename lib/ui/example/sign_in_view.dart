import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExampleView extends StatelessWidget {
  const ExampleView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(color: Colors.red[600]),
            ),
            Expanded(
              child: Container(color: Colors.blue[600]),
            )
          ],
        ),
      ),
    );
  }
}
