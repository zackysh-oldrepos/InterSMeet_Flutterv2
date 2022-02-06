import 'package:flutter/material.dart';
import 'package:intersmeet/ui/home/home_scaffold.dart';

class HomeViewArguments {
  final String? snackMessage;

  HomeViewArguments(this.snackMessage);
}

class HomeView extends StatelessWidget {
  final String? message;
  const HomeView({Key? key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      final dynamic args = ModalRoute.of(context)!.settings.arguments;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(args?.snackMessage ?? 'Sign-in successfully!'),
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
