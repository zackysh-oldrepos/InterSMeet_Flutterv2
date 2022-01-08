import 'package:flutter/material.dart';
import 'package:intersmeet/ui/home/home_scaffold.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sign-in successfully!'),
        ),
      );
    });
    return HomeScaffold(
      body: SafeArea(
        child: Center(
          child: Container(color: Colors.indigo[900]),
        ),
      ),
    );
  }
}
