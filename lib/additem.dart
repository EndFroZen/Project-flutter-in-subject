import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:main/AuthProvider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MaterialApp(
    home: Additem(),
  ));
}

class Additem extends StatefulWidget {
  const Additem({super.key});

  @override
  _AdditemState createState() => _AdditemState();
}

class _AdditemState extends State<Additem> {
  XFile? _pickedImage;
  Uint8List? _webImage; // สำหรับ Web
  String base64files = "";
  final ImagePicker _picker = ImagePicker();

  // ฟังก์ชันแปลงภาพเป็น Base64
  Future<String> base64pass(Uint8List imageBytes) async {
    String base64String = base64Encode(imageBytes);
    return "data:image/jpeg;base64,$base64String";
  }

  // ฟังก์ชันอัปโหลดข้อมูลไป API
  Future<void> postItem(String name, String description, String location, String base64file) async {
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    final url = Uri.parse('https://arther.bxoks.online/postitem?Auth=$token');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "name": name,
          "description": description,
          "location": location,
          "file": base64file, // ส่ง base64 ของไฟล์
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('เพิ่มไอเท็มสำเร็จ!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("เกิดข้อผิดพลาด: ${response.body}")),
        );
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  // ฟังก์ชันเลือกรูปภาพจากแกลเลอรี่
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (kIsWeb) {
        // Web: อ่านเป็น Uint8List
        Uint8List webImage = await pickedFile.readAsBytes();
        setState(() {
          _webImage = webImage;
        });
      } else {
        // Mobile: ใช้ File
        setState(() {
          _pickedImage = pickedFile;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController locationController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF543310),
        title: const Text('เพิ่มไอเท็ม', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Container(
        color: const Color(0xFFF8F4E1),
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
                child: _pickedImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(_pickedImage!.path),
                          fit: BoxFit.cover,
                          width: 150,
                          height: 150,
                        ),
                      )
                    : _webImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.memory(
                              _webImage!,
                              fit: BoxFit.cover,
                              width: 150,
                              height: 150,
                            ),
                          )
                        : const Icon(Icons.camera_alt, size: 50, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: locationController,
              decoration: const InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isEmpty ||
                    descriptionController.text.isEmpty ||
                    locationController.text.isEmpty ||
                    (_pickedImage == null && _webImage == null)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('กรุณากรอกข้อมูลให้ครบทุกช่อง')),
                  );
                } else {
                  String base64file = "";
                  if (kIsWeb && _webImage != null) {
                    base64file = await base64pass(_webImage!);
                  } else if (_pickedImage != null) {
                    File imageFile = File(_pickedImage!.path);
                    Uint8List imageBytes = await imageFile.readAsBytes();
                    base64file = await base64pass(imageBytes);
                  }

                  await postItem(nameController.text, descriptionController.text, locationController.text, base64file);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF543310),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                elevation: 5,
              ),
              child: const Text(
                "POST ITEM",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
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
