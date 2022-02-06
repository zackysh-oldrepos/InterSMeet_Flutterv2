import 'package:flutter/material.dart';
import 'package:intersmeet/ui/home/home_scaffold.dart';

class HomeViewArguments {
  final String? snackMessage;

  HomeViewArguments(this.snackMessage);
}

class HomeView extends StatefulWidget {
  final String? message;
  const HomeView({Key? key, this.message}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      final dynamic args = ModalRoute.of(context)!.settings.arguments;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(args?.snackMessage ?? 'Sign-in successfully!'),
        ),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return HomeScaffold(
      body: SafeArea(
        child: Center(
          child: Container(color: Colors.indigo[900]),
        ),
      ),
    );
  }
}
