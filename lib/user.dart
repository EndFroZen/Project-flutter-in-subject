import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:main/widgets/bottom_nav_bar.dart';

class User extends StatefulWidget {
  final String authToken;

  const User({super.key, required this.authToken});

  @override
  _UserState createState() => _UserState();
}

class _UserState extends State<User> {
  String name = "Loading...";
  String phone = "Loading...";
  String email = "Loading...";
  String? profileImage;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    if (widget.authToken.isEmpty) {
      print("No token provided, redirecting to login...");
      return;
    }

    final url = Uri.parse('http://endforzen/user-profile');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer ${widget.authToken}'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        name = data['name'] ?? "No Name";
        phone = data['phone'] ?? "No Phone";
        email = data['email'] ?? "No Email";
        profileImage = data['profile_image'];
      });
    } else {
      print("Failed to load profile: ${response.body}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Profile"),
        backgroundColor: const Color(0xFF543310),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: profileImage != null
                  ? NetworkImage(profileImage!)
                  : const AssetImage("assets/default_profile.png") as ImageProvider,
            ),
            const SizedBox(height: 10),
            const Text("User Profile",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 20),
            Card(
              elevation: 2,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text("Name"),
                    subtitle: Text(name),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.phone),
                    title: const Text("Phone Number"),
                    subtitle: Text(phone),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.email),
                    title: const Text("Email"),
                    subtitle: Text(email),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
    );
  }
}
