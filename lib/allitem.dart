import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dotted_border/dotted_border.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

var log = Logger();

Future<String?> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('token'); // ดึง token
}

class AllItem extends StatelessWidget {
  const AllItem({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ItemListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Item {
  final int id; // เพิ่ม id
  final String name;
  final String description;
  final String imagePath;
  final String account;
  final String location;

  Item({
    required this.id, // เพิ่ม id
    required this.name,
    required this.description,
    required this.imagePath,
    required this.account,
    required this.location,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['ID'] ?? 0, // Provide a default value if null
      name: json['Name'] ?? 'Unknown', // Provide a default value if null
      description: json['Description'] ??
          'No description', // Provide a default value if null
      imagePath: json['Imagepath'] ?? '', // Provide a default value if null
      account: json['UserInfo']?['Name'] ??
          'Unknown', // Provide a default value if null
      location: "dasdawdawdawd", // This seems to be a hardcoded value
    );
  }
}

class ItemListScreen extends StatefulWidget {
  @override
  _ItemListScreenState createState() => _ItemListScreenState();
}

class _ItemListScreenState extends State<ItemListScreen> {
  late Future<List<Item>> items;

  Future<List<Item>> fetchItems() async {
    String? token = await getToken();
    log.d("Token: $token");

    final response = await http.get(
      Uri.parse('http://26.65.220.249:3023/api/allitem?Auth=$token'),
    );

    if (response.statusCode == 200) {
      final String responseBody = utf8.decode(response.bodyBytes);
      List jsonResponse = json.decode(responseBody);
      log.d(jsonResponse);
      return jsonResponse.map((item) => Item.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load items');
    }
  }

  @override
  void initState() {
    super.initState();
    items = fetchItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F4E1),
      appBar: AppBar(
        title: Text('Item List', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF543310),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: DottedBorder(
          color: Colors.black,
          strokeWidth: 3,
          dashPattern: [10, 5],
          borderType: BorderType.RRect,
          radius: Radius.circular(15),
          padding: EdgeInsets.all(10),
          child: FutureBuilder<List<Item>>(
            future: items,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final item = snapshot.data![index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ItemDetailScreen(item: item),
                          ),
                        );
                      },
                      child: ItemCard(item: item),
                    );
                  },
                );
              } else {
                return Center(child: Text('No items found.'));
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Color(0xFF543310),
      ),
    );
  }
}

class ItemCard extends StatelessWidget {
  final Item item;

  const ItemCard({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: Offset(2, 2),
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.network(
                'http://26.65.220.249:3023/api/image${item.imagePath}',
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: TextStyle(fontWeight: FontWeight.bold)),
                Text('by ${item.account}', style: TextStyle(fontSize: 12)),
                Text(item.description, style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ItemDetailScreen extends StatelessWidget {
  final Item item;

  const ItemDetailScreen({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F4E1),
      appBar: AppBar(
        title: Text(item.name, style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF543310),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  'http://26.65.220.249:3023/api/image${item.imagePath}',
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(item.name,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text('by ${item.account}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text(item.description, style: TextStyle(fontSize: 16)),
            Spacer(),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.swap_horiz, color: Colors.white, size: 40),
                label: Text('แลกเปลี่ยน',
                    style: TextStyle(color: Colors.white, fontSize: 20)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF74512D),
                  padding: EdgeInsets.all(20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
