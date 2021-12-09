import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intersmeet/ui/home/home_scaffold.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HomeScaffold(
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
