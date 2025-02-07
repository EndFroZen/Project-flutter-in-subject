import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
var log = Logger();
Future<String?> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('token');
}

class ItemDetailScreen extends StatelessWidget {
  
  final String id;
  final String name;
  final String account;
  final String imagePath;
  final String description;
  final String location;

  const ItemDetailScreen({
  Key? key,
  required this.id,
  required this.name,
  required this.account,
  required this.imagePath,
  required this.description,
  required this.location,
}) : super(key: key) {
  log.d('Item Details - Id: $id, Name: $name, Account: $account, Image: $imagePath, Description: $description, Location: $location');
}

  @override
  Widget build(BuildContext context) {
    log.d('Description in build: $description');
    return Scaffold(
      backgroundColor: Color(0xFFF8F4E1),
      appBar: AppBar(
        backgroundColor: Color(0xFF543310),
        automaticallyImplyLeading: false, // ซ่อนปุ่ม back อัตโนมัติ
        title: Row(
          children: [
            IconButton(
              icon: Icon(Icons.close, color: Colors.white, size: 28),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(width: 8),
            Text(
              name,
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DottedBorder(
              color: Colors.black,
              strokeWidth: 3,
              dashPattern: [10, 5],
              borderType: BorderType.RRect,
              radius: Radius.circular(12),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    // รูปภาพ
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue, width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          imagePath,
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    // ชื่อและข้อมูล
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'by $account',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '$description',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          Spacer(),
          // ปุ่มแลกเปลี่ยน
          Container(
            padding: EdgeInsets.only(bottom: 20),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                padding: EdgeInsets.all(20),
                backgroundColor: Color(0xFF74512D),
              ),
              child: Icon(Icons.swap_horiz, color: Colors.white, size: 40),
            ),
          ),
        ],
      ),
    );
  }
}
