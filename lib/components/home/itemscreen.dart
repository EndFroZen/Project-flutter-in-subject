import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const host = "http://192.168.1.3:4050";

class Itemscreen extends StatelessWidget {
  const Itemscreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String pathitem =
        ModalRoute.of(context)?.settings.arguments as String? ?? "/defaultPath";

    Future<Map<String, dynamic>> fetchData() async {
      try {
        final response = await http.get(Uri.parse('$host$pathitem'));

        if (response.statusCode == 200) {
          var decodedData = json.decode(utf8.decode(response.bodyBytes));
          return decodedData[
              0]; // Assuming the data is a list and taking the first item.
        } else {
          throw Exception('Failed to load data: ${response.statusCode}');
        }
      } catch (e) {
        debugPrint('Error fetching data: $e');
        rethrow;
      }
    }

    return FutureBuilder<Map<String, dynamic>>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return const Center(child: Text('No data available'));
        }

        final itemData = snapshot.data!;
        return ImageDetailScreen(itemData: itemData);
      },
    );
  }
}

class ImageDetailScreen extends StatelessWidget {
  final Map<String, dynamic> itemData;

  const ImageDetailScreen({required this.itemData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 320,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                    image: DecorationImage(
                      image:
                          NetworkImage('$host/api/image/${itemData["Image"]}'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              itemData['NameItem'] ?? 'No name',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              itemData['DescriptionItem'] ?? 'No description',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('ทำการแลกเปลี่ยนแล้ว!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    splashColor: Colors.white.withOpacity(0.3),
                    onTap: () {
                      debugPrint('ปุ่มแลกเปลี่ยนกด');
                    },
                    child: Container(
                      width: 300,
                      height: 100,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF05454),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.sync_alt,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
