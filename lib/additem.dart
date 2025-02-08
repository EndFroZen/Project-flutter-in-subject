import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:main/AuthProvider.dart';
import 'dart:io';
import 'package:main/allitem.dart';
import 'package:provider/provider.dart';

void main() => runApp(const Additem());

class Additem extends StatelessWidget {
  const Additem({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: AddItemScreen(),
    );
  }
}

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  File? _image; // ตัวแปรเก็บรูปภาพที่เลือก
  String base64files = "";
  final ImagePicker _picker = ImagePicker();

  // ฟังก์ชันแปลงภาพเป็น base64 และเพิ่ม data:image/jpeg;base64,
  Future<String> base64pass(File image) async {
    List<int> imageBytes = image.readAsBytesSync();
    String base64String = base64Encode(imageBytes);
    return "data:image/jpeg;base64,$base64String";
  }

  // ฟังก์ชันโพสต์ข้อมูลไปยัง API
  Future<void> postitem(String name, String description, String location,
      String base64file) async {
    print(name);
    print(base64file); // ดูค่าที่จะส่งไป
    print(description);
    print(location);

    final token = Provider.of<AuthProvider>(context, listen: false).token;
    final url = Uri.parse('http://26.65.220.249:3023/postitem?Auth=$token');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "name": name,
          "description": description,
          'location': location, // แก้ไขคำผิดจาก 'Loaction' เป็น 'Location'
          'file': base64file, // ส่ง base64 ของไฟล์
        }),
      );

      if (response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AllItem()),
        );
      } else {
        print("Error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController name = TextEditingController();
    TextEditingController description = TextEditingController();
    TextEditingController location = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF543310),
        title: const Text('เพิ่มไอเท็ม', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AllItem()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.white),
            onPressed: () {
              // ฟังก์ชันสำหรับปุ่มยืนยัน
            },
          ),
        ],
      ),
      body: Container(
        color: const Color(0xFFF8F4E1),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.black54, width: 1),
                  ),
                  child: _image != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            _image!,
                            fit: BoxFit.cover,
                            width: 150,
                            height: 150,
                          ),
                        )
                      : const Icon(Icons.camera_alt,
                          size: 50, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: name,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: description,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: location,
                decoration: const InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (name.text.isEmpty ||
                      description.text.isEmpty ||
                      location.text.isEmpty ||
                      _image == null) {
                    // ตรวจสอบว่าได้เลือกภาพหรือยัง
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('กรุณากรอกข้อมูลให้ครบทุกช่อง')),
                    );
                  } else {
                    String base64file = await base64pass(
                        _image!); // ส่งภาพที่เลือกไปแปลงเป็น base64 พร้อม prefix
                    await postitem(
                        name.text, description.text, location.text, base64file);
                  }
                },
                child: const Text(
                  "POST ITEM",
                  style: TextStyle(
                    color: Colors.white, // Text color
                    fontWeight: FontWeight.bold, // Make the text bold
                    fontSize: 16, // Adjust font size
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown, // Button color (brown)
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12), // Padding
                  elevation: 5, // Add shadow for depth
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ฟังก์ชันเลือกภาพจากแกลเลอรี่
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }
}
