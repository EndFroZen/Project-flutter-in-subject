import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:main/AuthProvider.dart';
import 'package:main/widgets/bottom_nav_bar.dart';
import 'package:provider/provider.dart';

var log = Logger();

void main() {
  runApp(const MailApp());
}

class MailApp extends StatelessWidget {
  const MailApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChangeNotifierProvider(
        create: (context) => AuthProvider(),
        child: const Mail(),
      ),
    );
  }
}

class Mail extends StatefulWidget {
  const Mail({super.key});

  @override
  _MailState createState() => _MailState();
}

class _MailState extends State<Mail> {
  List<dynamic> tradeItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final token = Provider.of<AuthProvider>(context, listen: false).token;
      final response = await http.get(
        Uri.parse("https://arther.bxoks.online/trade/dealer?Auth=$token"),
      );

      if (response.statusCode == 200) {
        final String responseBody = utf8.decode(response.bodyBytes);
        var jsonResponse = json.decode(responseBody);

        setState(() {
          tradeItems = jsonResponse ?? [];
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load items');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F4E1),
      appBar: AppBar(
        title: const Text('MAIL', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF543310),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : tradeItems.isEmpty
                      ? const Center(child: Text("No data available"))
                      : ListView.builder(
                          itemCount: tradeItems.length,
                          itemBuilder: (context, index) {
                            final trade = tradeItems[index];
                            final item1 = trade["Item1"];
                            final item2 = trade["Item2"];
                            final user1 = trade["User1"];
                            final user2 = trade["User2"];

                            return Card(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 16),
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        item1 != null &&
                                                item1["Imagepath"] != null
                                            ? Image.network(
                                                "https://arther.bxoks.online/api/image${item1["Imagepath"]}",
                                                width: 80,
                                                height: 80,
                                                fit: BoxFit.cover,
                                              )
                                            : const Icon(
                                                Icons.image_not_supported,
                                                size: 80),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  "${item1?["Name"] ?? 'No Name'} ⇄ ${item2?["Name"] ?? 'No Name'}",
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                              const SizedBox(height: 8),
                                              Text(
                                                  "Owner: ${user2?["Name"] ?? 'No Name'}"),
                                              Text(
                                                  "Trader: ${user1?["Name"] ?? 'No Name'}"),
                                              Text(
                                                "Status: ${trade["StatusTrade"] ?? 'No Status'}",
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.green),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        item2 != null &&
                                                item2["Imagepath"] != null
                                            ? Image.network(
                                                "https://arther.bxoks.online/api/image${item2["Imagepath"]}",
                                                width: 80,
                                                height: 80,
                                                fit: BoxFit.cover,
                                              )
                                            : const Icon(
                                                Icons.image_not_supported,
                                                size: 80),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                        "Owner Description: ${item1?["Discription"] ?? 'No Description'}"),
                                    Text(
                                        "Owner Location: ${item1?["Location"] ?? 'No Location'}"),
                                    const SizedBox(height: 5),
                                    Text(
                                        "Trader Description: ${item2?["Discription"] ?? 'No Description'}"),
                                    Text(
                                        "Trader Location: ${item2?["Location"] ?? 'No Location'}"),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 3),
    );
  }
}
