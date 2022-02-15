import 'package:flutter/material.dart';
import 'package:intersmeet/core/constants/colorsz.dart';
import 'package:intersmeet/ui/home/home_drawer.dart';

class HomeScaffold extends StatefulWidget {
  final Widget body;
  final Widget? title;
  final Widget? endDrawer;
  final GlobalKey<ScaffoldState>? drawerKey;
  const HomeScaffold({
    Key? key,
    required this.body,
    this.title,
    this.endDrawer,
    this.drawerKey,
  }) : super(key: key);

  @override
  _HomeScaffoldState createState() => _HomeScaffoldState();
}

class _HomeScaffoldState extends State<HomeScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget.drawerKey,
      appBar: appBar(context),
      body: widget.body,
      endDrawer: widget.endDrawer,
      drawer: const HomeDrawer(),
    );
  }

  PreferredSizeWidget appBar(BuildContext context) {
    return AppBar(
      iconTheme: IconTheme.of(context).copyWith(
        color: Colors.white,
      ),
      title: widget.title,
      backgroundColor: Colorz.complexDrawerBlack,
    );
  }
}
