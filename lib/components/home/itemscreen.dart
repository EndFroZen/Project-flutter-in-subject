import 'package:flutter/material.dart';

class Itemscreen extends StatelessWidget {
  const Itemscreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String pathitem =
        ModalRoute.of(context)?.settings.arguments as String? ?? "Unknown path";
    return MaterialApp(
      home: Scaffold(
        body: Text(pathitem),
      ),
    );
  }
}
