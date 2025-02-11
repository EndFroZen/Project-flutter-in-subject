import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:main/AuthProvider.dart';
import 'package:main/allitem.dart';
import 'package:main/widgets/bottom_nav_bar.dart';
import 'package:provider/provider.dart';

var log = Logger();

class SelectItemScreen extends StatelessWidget {
  final int itemId;

  const SelectItemScreen({super.key, required this.itemId});

  Future<List<dynamic>> ddfetchItems(BuildContext context, int id) async {
    final token = Provider.of<AuthProvider>(context, listen: false).token;

    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.get(
      Uri.parse('https://arther.bxoks.online/api/someitem/$id?Auth=$token'),
    );

    if (response.statusCode == 200) {
      final String responseBody = utf8.decode(response.bodyBytes);
      List jsonResponse = json.decode(responseBody);
      return jsonResponse;
    } else {
      throw Exception('Failed to load items');
    }
  }

  Future<void> postpostselect(
      BuildContext context, String tradeid, String ownder) async {
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    final url = Uri.parse('https://arther.bxoks.online/trade?Auth=$token');
    var dw = await ddfetchItems(context, itemId);
    var testdw = dw[0];

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "userownerid": testdw["UserInfoID"],
          "owneritemid": itemId,
          "tradeitemid": tradeid,
          "statustrade": "waiting",
        }),
      );

      if (response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AllItem()),
        );
      } else {
        print("Error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<List<dynamic>> fetchData(BuildContext context) async {
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    final response = await http
        .get(Uri.parse("https://arther.bxoks.online/api/myitem?Auth=$token"));

    if (response.statusCode == 200) {
      final String responseBody = utf8.decode(response.bodyBytes);
      var jsonResponse = json.decode(responseBody);
      return jsonResponse['item'] ??
          []; // Return an empty list if 'item' is null
    } else {
      throw Exception('Failed to load items');
    }
  }

  void _showItemDetails(BuildContext context, dynamic item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(item['Name']),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Description: ${item['Discription']}'),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      postpostselect(context, item["ID"].toString(),
                          item["UserInfoID"].toString());
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AllItem()),
                      );
                    },
                    child: const Text('Exchange'),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF543310),
        title: const Text(
          "Select Item",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchData(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.hasData) {
            List<dynamic> items = snapshot.data!;

            if (items.isEmpty) {
              return const Center(child: Text('ยังไม่มีรายการไอเท็มให้เลือก'));
            }

            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final imageUrl =
                    "https://arther.bxoks.online/api/image" + item['Imagepath'];
                return GestureDetector(
                  onTap: () => _showItemDetails(context, item),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 8,
                    shadowColor: Colors.black.withOpacity(0.3),
                    color: Colors.blueGrey.shade100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius:
                              const BorderRadius.vertical(top: Radius.circular(15)),
                          child: Image.network(
                            imageUrl,
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            item['Name'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.blueGrey.shade800,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            item['Discription'],
                            style: TextStyle(
                                fontSize: 14, color: Colors.blueGrey.shade600),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return const Center(child: Text('No data available'));
        },
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
    );
  }
}
