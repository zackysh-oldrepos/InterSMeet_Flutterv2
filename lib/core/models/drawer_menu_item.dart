import 'package:flutter/material.dart';

class DrawerMenuItem {
  final IconData icon;
  final String title;
  final String route;
  final List<String> submenus;

  DrawerMenuItem(
    this.icon,
    this.title,
    this.route,
    this.submenus,
  );
}
