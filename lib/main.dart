import 'package:flutter/material.dart';
import 'package:project/components/home/logout.dart';
import 'package:project/components/home/maintrade.dart';
import 'package:project/components/login.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: "/login",
    routes: {
      "/login": (context) => const Login(),
      "/maintrade": (context) => const Maintrade(),
      "/logout": (context) => const Logout(),
      // "/setting":(context)=>const ,
      // "/trade":(context)=>const ,
      // "/account":(context)=>const ,
      // "/notification":(context)=>const ,
    },
    home: const Scaffold(
      body: Column(
        children: [Text("1")],
      ),
    ),
  ));
}
