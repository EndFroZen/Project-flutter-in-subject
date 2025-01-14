import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

const host = "http://10.50.18.116:4050";
var logger = Logger();

class Maintrade extends StatelessWidget {
  const Maintrade({super.key});

  Future<List<dynamic>> fetchData() async {
    try {
      final response = await http.get(Uri.parse('$host/api/tredeitem'));

      if (response.statusCode == 200) {
        var decodedData = json.decode(utf8.decode(response.bodyBytes));
        logger.d(decodedData);
        return decodedData;
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      logger.e('Error fetching data: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('TradeON'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${snapshot.error}'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Trigger rebuild to retry fetching data
                      fetchData();
                    },
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          } else {
            final data = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.6,
                ),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final item = data[index];
                  return ItemBox(item: item);
                },
              ),
            );
          }
        },
      ),
    );
  }
}

class ItemBox extends StatelessWidget {
  final dynamic item;

  const ItemBox({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final String name = item["NameItem"] ?? "Unknown Item";
    final String createdAt = item["CreatedAt"] ?? "Unknown Date";
    final String image = item["Image"] ?? "default_image.png";
    final String pathitem = item["Pathitem"] ?? "Unknown path";

    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, "/itemscreen", arguments: pathitem);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8.0,
              offset: const Offset(0, 4),
            ),
          ],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              "$host/api/image/$image",
              width: double.infinity,
              fit: BoxFit.cover,
              height: 200,
              errorBuilder: (context, error, stackTrace) {
                return const Center(child: Icon(Icons.broken_image, size: 50));
              },
            ),
            const SizedBox(height: 5),
            Text(
              name,
              style: const TextStyle(fontSize: 20),
            ),
            Text(
              createdAt,
              style: TextStyle(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 40),
            const Text("2000km"),
          ],
        ),
      ),
    );
  }
}
