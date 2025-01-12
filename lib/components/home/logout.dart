import 'package:flutter/material.dart';

class Logout extends StatelessWidget {
  const Logout({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/maintrade");
                },
                child: const Text("BACK"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/login");
                },
                child: const Text("LOGOUT"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
