import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dotted_border/dotted_border.dart';
import 'package:logger/logger.dart';
import 'package:main/AuthProvider.dart';
import 'package:main/additem.dart';
import 'package:main/selecttreade.dart';
import 'package:main/widgets/bottom_nav_bar.dart';
import 'package:provider/provider.dart';

var log = Logger();


class AllItem extends StatelessWidget {
  const AllItem({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF8F4E1),
      body: ItemListScreen(),
      bottomNavigationBar: BottomNavBar(currentIndex: 0),
    );
  }
}

class Item {
  final int id;
  final String name;
  final String description;
  final String imagePath;
  final String account;
  final String location;

  Item({
    required this.id,
    required this.name,
    required this.description,
    required this.imagePath,
    required this.account,
    required this.location,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['ID'] ?? 0,
      name: json['Name'] ?? 'Unknown',
      description: json['Discription'] ?? 'No description',
      imagePath: json['Imagepath'] ?? '',
      account: json['UserInfo']?['Name'] ?? 'Unknown',
      location: "Unknown Location",
    );
  }
}

class ItemListScreen extends StatefulWidget {
  const ItemListScreen({super.key});

  @override
  _ItemListScreenState createState() => _ItemListScreenState();
}

class _ItemListScreenState extends State<ItemListScreen> {
  late Future<List<Item>> items;

  Future<List<Item>> fetchItems() async {
    final token = Provider.of<AuthProvider>(context, listen: false).token;

    if (token == null) {
      throw Exception('No token found');
    }



    final response = await http.get(
      Uri.parse('http://26.65.220.249:3023/api/allitem?Auth=$token'),
    );

    if (response.statusCode == 200) {
      final String responseBody = utf8.decode(response.bodyBytes);
      List jsonResponse = json.decode(responseBody);

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
      backgroundColor: const Color(0xFFF8F4E1),
      appBar: AppBar(
        title: const Text('Item List', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF543310),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: DottedBorder(
          color: Colors.black,
          strokeWidth: 3,
          dashPattern: const [10, 5],
          borderType: BorderType.RRect,
          radius: const Radius.circular(15),
          padding: const EdgeInsets.all(10),
          child: FutureBuilder<List<Item>>(
            future: items,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                return const Center(child: Text('No items found.'));
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Additem()),
          );
        },
        backgroundColor: const Color(0xFF543310),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Icon(Icons.add, size: 38, color: Colors.white),
      ),
    );
  }
}

class ItemCard extends StatelessWidget {
  final Item item;

  const ItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(2, 2),
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.network(
                'http://26.65.220.249:3023/api/image${item.imagePath}',
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image, size: 50);
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('by ${item.account}',
                    style: const TextStyle(fontSize: 12)),
                Text(item.location, style: const TextStyle(fontSize: 12)),
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

  const ItemDetailScreen({super.key, required this.item});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F4E1),
      appBar: AppBar(
        title: Text(item.name, style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF543310),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  'http://26.65.220.249:3023/api/image${item.imagePath}',
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.broken_image, size: 100);
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(item.name,
                style:
                    const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('By: ${item.account}',
                style:
                    const TextStyle(fontSize: 18, fontStyle: FontStyle.italic)),
            const SizedBox(height: 10),
            Text('Descrption: ${item.description}',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Location: ${item.location}',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 100),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          SelectItemScreen(itemId: item.id), // ✅ ส่งค่า itemId
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF543310),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Icon(Icons.compare_arrows,
                    color: Colors.white, size: 60),
              ),
            )
          ],
        ),
      ),
    );
  }
}
