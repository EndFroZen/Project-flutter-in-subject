import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Text("hello"),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/maintrade");
                },
                child: Text("login"))
          ],
        ),
      ),
    );
  }
}
