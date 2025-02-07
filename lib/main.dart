import 'package:flutter/material.dart';
import 'package:main/AuthProvider.dart';
import 'package:main/additem.dart';
import 'package:main/allitem.dart';
import 'package:main/login.dart';
import 'package:main/user.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
      ],
      child: const LinkPage(),
    ),
  );
}

class LinkPage extends StatelessWidget {
  const LinkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      initialRoute: "/login",
      routes: {
        // "/login": (context) => AllItem(),
        "/login": (context) => const Loginpage(),
        "/alliten": (context) => const AllItem(),
        "/additem": (context) => const Additem(),
        "/user": (context) => const User(
              authToken: '',
            ),
      },
    );
  }
}
