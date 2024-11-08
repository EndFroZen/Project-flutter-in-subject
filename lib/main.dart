import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade100,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // จัดให้อยู่กลางจอ
          children: <Widget>[
            const SizedBox(height: 280),
            const Text(
              'BYTE',
              style: TextStyle(
                fontSize: 48, // ขนาด 48 "BYTE"
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10), // เว้นระยะห่าง BYTE และ start app
            const Text(
              'start app',
              style: TextStyle(
                fontSize: 24, // ขนาดตัวอักษร 24 "BYTE"
              ),
            ),
            const Spacer(), // ดัน "tap to continue" ให้ไปอยู่ล่างสุด
            const Padding(
              padding: EdgeInsets.only(bottom: 16), // เพิ่มระยะขอบล่าง 
              child: Text(
                'tap to continue',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
