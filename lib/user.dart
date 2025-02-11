import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:main/AuthProvider.dart';
import 'package:main/widgets/bottom_nav_bar.dart';

var log = Logger();

class User {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String? profileImage;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.profileImage,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['ID'] ?? 0,
      name: json['Name'] ?? 'Unknown',
      email: json['Email'] ?? 'No Email',
      phone: json['Phone'] ?? 'No Phone Number',
      profileImage: json['ProfileImage'],
    );
  }
}

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  User? user;
  List<dynamic> items = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      final token = Provider.of<AuthProvider>(context, listen: false).token;
      final response = await http.get(
        Uri.parse("https://arther.bxoks.online/api/myitem?Auth=$token"),
      );

      if (response.statusCode == 200) {
        final String responseBody = utf8.decode(response.bodyBytes);
        var jsonResponse = json.decode(responseBody);

        setState(() {
          user = User.fromJson(jsonResponse['user']);
          items = jsonResponse['item'] ?? [];

          isLoading = false;
        });
      } else {
        throw Exception('Failed to load user profile');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint("Error fetching user profile: $e");
    }
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); 
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _logout(); 
              },
              child: const Text('Logout', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

void _logout() {
  final authProvider = Provider.of<AuthProvider>(context, listen: false);
  authProvider.logout(); // ล้าง token
  Future.delayed(Duration(milliseconds: 500), () {
    if (authProvider.token == null) {
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    }
  });
}


  void _showDeleteConfirmationDialog(BuildContext context, var item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete ${item['Name']}?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                await _deleteItem(item); // Perform the deletion
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteItem(var item) async {
    try {
      final token = Provider.of<AuthProvider>(context, listen: false).token;
      final response = await http.delete(
        Uri.parse(
            "https://arther.bxoks.online/api/deleteitem/${item['ID']}?Auth=$token"),
      );

      if (response.statusCode == 200) {
        setState(() {
          items.remove(item);
        });
      } else {
        throw Exception('Failed to delete item');
      }
    } catch (e) {
      debugPrint("Error deleting item: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F4E1),
      appBar: AppBar(
        title: const Text("User Profile"),
        backgroundColor: const Color(0xFF543310),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _confirmLogout, 
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : user == null
                ? const Center(child: Text("Failed to load user data"))
                : Column(
                    children: [
                      // Profile Image
                      // CircleAvatar(
                      //   radius: 50,
                      //   backgroundImage: user!.profileImage != null
                      //       ? NetworkImage(user!.profileImage!)
                      //       : const AssetImage("assets/default_profile.png")
                      //           as ImageProvider,
                      // ),
                      const SizedBox(height: 10),
                      Text(user!.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 32)),
                      const SizedBox(height: 20),

                      // User Information Card
                      Card(
                        elevation: 2,
                        child: Column(
                          children: [
                            ListTile(
                              leading: const Icon(Icons.person),
                              title: const Text("Name"),
                              subtitle: Text(user!.name),
                            ),
                            const Divider(),
                            ListTile(
                              leading: const Icon(Icons.phone),
                              title: const Text("Phone Number"),
                              subtitle: Text(user!.phone),
                            ),
                            const Divider(),
                            ListTile(
                              leading: const Icon(Icons.email),
                              title: const Text("Email"),
                              subtitle: Text(user!.email),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Item List
                      Expanded(
                        child: ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            var item = items[index];
                            return Card(
                              elevation: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  item['Imagepath'] != null
                                      ? Image.network(
                                          "https://arther.bxoks.online/api/image${item['Imagepath']}",
                                          height: 100,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error,
                                                  stackTrace) =>
                                              const Icon(
                                                  Icons.image_not_supported),
                                        )
                                      : const SizedBox(),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            item['Name'],
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete,
                                              color: Colors.red),
                                          onPressed: () =>
                                              _showDeleteConfirmationDialog(
                                                  context, item),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
    );
  }
}
