import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:main/AuthProvider.dart';
import 'package:main/allitem.dart';
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
      Uri.parse('http://26.65.220.249:3023/api/someitem/$id?Auth=$token'),
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
    final url = Uri.parse('http://26.65.220.249:3023/trade?Auth=$token');
    print(tradeid);
    print(itemId);
    print(ownder);
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
          MaterialPageRoute(builder: (context) => AllItem()),
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
        .get(Uri.parse("http://26.65.220.249:3023/api/myitem?Auth=$token"));

    if (response.statusCode == 200) {
      final String responseBody = utf8.decode(response.bodyBytes);
      var jsonResponse = json.decode(responseBody);

      // Now using the 'item' key from the JSON response
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
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Convert item["ID"] and item["UserInfoID"] to String
                      postpostselect(context, item["ID"].toString(),
                          item["UserInfoID"].toString());
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AllItem()),
                      );
                    },
                    child: Text('Exchange'),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Item")),
      body: FutureBuilder<List<dynamic>>(
        future: fetchData(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.hasData) {
            List<dynamic> items = snapshot.data!;

            if (items.isEmpty) {
              return Center(child: Text('ยังไม่มีรายการไอเท็มให้เลือก'));
            }

            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final imageUrl =
                    "http://26.65.220.249:3023/api/image" + item['Imagepath'];
                return GestureDetector(
                  onTap: () => _showItemDetails(context, item),
                  child: Card(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                    child: ListTile(
                      contentPadding: EdgeInsets.all(12),
                      title: Text(
                        item['Name'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        item['Discription'],
                        overflow: TextOverflow.ellipsis,
                      ),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          imageUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return Center(child: Text('No data available'));
        },
      ),
    );
  }
}
