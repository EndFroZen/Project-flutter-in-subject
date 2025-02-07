import 'package:flutter/material.dart';
import 'package:tradeon/login.dart';
import 'package:tradeon/allitem.dart';

void main() {
  runApp(const linkpage());
}

class linkpage extends StatelessWidget {
  const linkpage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/login",
      routes: {
        "/login": (context) => Loginpage(),
        '/allitem': (context) => AllItem(),
      },
    );
  }
}
