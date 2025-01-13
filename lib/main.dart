import 'package:flutter/material.dart';
import 'package:project/components/home/itemscreen.dart';

import 'package:project/components/home/logout.dart';
import 'package:project/components/wrapper/page/account.dart';
import 'package:project/components/wrapper/page/maintrade.dart';
import 'package:project/components/wrapper/mainwarpper.dart';
import 'package:project/components/home/setting.dart';
import 'package:project/components/login.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: "/login",
    routes: {
      "/login": (context) => Login(),
      "/mainwrapper": (context) => const Mainwarpper(),
      "/maintrade": (context) => const Maintrade(),
      "/logout": (context) => const Logout(),
      "/setting": (context) => const Setting(),
      "/itemscreen": (context) => const Itemscreen(),
      "/account": (context) => const Account(),
    },
  ));
}
