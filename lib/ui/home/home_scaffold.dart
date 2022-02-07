import 'package:flutter/material.dart';
import 'package:intersmeet/core/constants/colorsz.dart';
import 'package:intersmeet/ui/home/home_drawer.dart';

class HomeScaffold extends StatelessWidget {
  final Widget body;
  const HomeScaffold({Key? key, required this.body}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: body,
      drawer: const HomeDrawer(),
    );
  }

  PreferredSizeWidget appBar(BuildContext context) {
    return AppBar(
      iconTheme: IconTheme.of(context).copyWith(
        color: Colors.white,
      ),
      backgroundColor: Colorz.complexDrawerBlack,
    );
  }
}
