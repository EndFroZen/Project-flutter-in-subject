import 'package:flutter/material.dart';

class Setting extends StatelessWidget {
  const Setting({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('ตั้งค่า'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'การตั้งค่าโปรไฟล์',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              // ชื่อผู้ใช้งาน
              TextField(
                decoration: InputDecoration(
                  labelText: 'ชื่อผู้ใช้งาน',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              // สลับการตั้งค่า (เช่น การเปิดหรือปิดการแจ้งเตือน)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'เปิดการแจ้งเตือน',
                    style: TextStyle(fontSize: 18),
                  ),
                  Switch(
                    value: true,
                    onChanged: (value) {
                      // การเปลี่ยนแปลงสถานะ
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // ปุ่มบันทึก
              ElevatedButton(
                onPressed: () {
                  // ทำการบันทึกข้อมูล
                },
                child: const Text('บันทึกการตั้งค่า'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
