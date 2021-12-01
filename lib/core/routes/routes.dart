import 'package:flutter/material.dart';
import 'package:intersmeet/ui/welcome/welcome_view.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    '/': (BuildContext context) => const WelcomeView()
  };
}
