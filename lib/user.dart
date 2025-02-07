import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class UserProfileScreen extends StatefulWidget {
  final String authToken; // รับ token จากที่อื่น (เช่นจาก login screen)

  const UserProfileScreen({Key? key, required this.authToken})
      : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
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
        nameController.text = data['name'];
        phoneController.text = data['phone'];
        emailController.text = data['email'];
        profileImage = data['profile_image'];
      });
    } else {
      print("Failed to load profile: ${response.body}");
    }
  }

  Future<void> _updateProfile() async {
    if (widget.authToken.isEmpty) return;

    final url = Uri.parse('http://endforzen/update-profile');
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer ${widget.authToken}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': nameController.text,
        'phone': phoneController.text,
      }),
    );

    if (response.statusCode == 200) {
      print("Profile updated successfully");
    } else {
      print("Failed to update profile: ${response.body}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Profile"),
        backgroundColor: Color(0xFF543310),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile Picture
            CircleAvatar(
              radius: 50,
              backgroundImage: profileImage != null
                  ? NetworkImage(profileImage!)
                  : AssetImage("assets/default_profile.png") as ImageProvider,
            ),
            SizedBox(height: 10),
            Text("User Profile", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            // Name
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 10),
            // Phone
            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            SizedBox(height: 10),
            // Email (Read Only)
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
              readOnly: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateProfile,
              child: Text("Update Profile"),
            ),
          ],
        ),
      ),
    );
  }
}
