import 'package:flutter/material.dart';
import 'package:project/components/home/maintrade.dart';
import 'package:project/components/login.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: "/login",
    routes: {
      "/login": (context) => const Login(),
      "/maintrade": (context) => const Maintrade(),
    },
    home: Scaffold(
      body: Column(
        children: [Text("1")],
      ),
    ),
  ));
}
