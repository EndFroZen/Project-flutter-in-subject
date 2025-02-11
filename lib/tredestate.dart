import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:main/AuthProvider.dart';
import 'package:main/allitem.dart';
import 'package:main/widgets/bottom_nav_bar.dart';
import 'package:provider/provider.dart';

var log = Logger();

void main() {
  runApp(const ScreenTradeApp());
}

class ScreenTradeApp extends StatelessWidget {
  const ScreenTradeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChangeNotifierProvider(
        create: (context) => AuthProvider(),
        child: const ScreenTrade(),
      ),
    );
  }
}

class ScreenTrade extends StatefulWidget {
  const ScreenTrade({super.key});

  @override
  _ScreenTradeState createState() => _ScreenTradeState();
}

class _ScreenTradeState extends State<ScreenTrade> {
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
        Uri.parse("https://arther.bxoks.online/trade/waiting?Auth=$token"),
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

  Future<void> handleTradeAction(BuildContext context, int tradeID ,String State) async {
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    final url = Uri.parse('https://arther.bxoks.online/trade/update?Auth=$token');
  
    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "tradeidnumber":tradeID,
          "statustrade": State,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F4E1),
      appBar: AppBar(
        title: const Text('TRADE START', style: TextStyle(color: Colors.white)),
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
                            final tradeId = trade["TradeId"];

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
                                    children: [
                                      Row(
                                        children: [
                                          item1["Imagepath"] != null
                                              ? Image.network(
                                                  "https://arther.bxoks.online/api/image${item2["Imagepath"]}",
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
                                                  "${item2["Name"]} ⇄ ${item1["Name"]}",
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  "Owner: ${user2["Name"]}",
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                Text(
                                                  "Trader:${user1["Name"]}",
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                Text(
                                                  "Status: ${trade["StatusTrade"]}",
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Color.fromARGB(
                                                          255, 255, 163, 52)),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          item2["Imagepath"] != null
                                              ? Image.network(
                                                  "https://arther.bxoks.online/api/image${item1["Imagepath"]}",
                                                  width: 80,
                                                  height: 80,
                                                  fit: BoxFit.cover,
                                                )
                                              : const Icon(
                                                  Icons.image_not_supported,
                                                  size: 80),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          btntogetstate("❌DENY", 0xFFFF7A6B,
                                              () {
                                            handleTradeAction(
                                                context, trade["ID"], "deny");
                                          }),
                                          btntogetstate("DEALER✅", 0xFF5BFF63,
                                              () {
                                            handleTradeAction(
                                                context, trade["ID"], "dealer");
                                          }),
                                        ],
                                      )
                                    ],
                                  )),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }
}

Widget btntogetstate(String text, int color, VoidCallback onPressed) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(color),
    ),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 20,
      ),
    ),
  );
}

Widget buttonState(String data, int color) {
  return ElevatedButton(
    onPressed: () {},
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(color),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    ),
    child: Text(
      data,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
