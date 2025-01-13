import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:project/addon/maindrawer.dart';

const host = "http://192.168.1.3:4050";
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
      drawer: const Maindrawer(),
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('TradeON'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
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
                  return itemBox(context, item);
                },
              ),
            );
          }
        },
      ),
    );
  }
}

Widget itemBox(context, dynamic item) {
  final String name = item["NameItem"] ?? "Unknown Item";
  final String createdAt = item["CreatedAt"] ?? "Unknown Date";
  final String image = item["Image"] ?? "default_image.png";
  final String pathitem = item["Pathitem"] ?? "Unknow path";
  logger.i(image);
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
            offset: Offset(0, 4),
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
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(child: CircularProgressIndicator());
            },
          ),
          const SizedBox(height: 5),
          Text(
            name,
            style: TextStyle(fontSize: 20),
          ),
          Text(
            createdAt,
            style: TextStyle(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 40),
          Text("2000km"),
        ],
      ),
    ),
  );
}
