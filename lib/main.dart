import 'package:flutter/material.dart';
import 'package:project/components/home/itemscreen.dart';
import 'package:project/components/home/logout.dart';
import 'package:project/components/home/maintrade.dart';
import 'package:project/components/home/setting.dart';
import 'package:project/components/login.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: "/login",
    routes: {
      "/login": (context) => Login(),
      "/maintrade": (context) => const Maintrade(),
      "/logout": (context) => const Logout(),
      "/itemscreen": (context) => const Itemscreen(),
      "/setting": (context) => const Setting(),
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
