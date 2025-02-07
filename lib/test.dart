import 'package:flutter/material.dart';
import 'package:main/AuthProvider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();
TextEditingController confirmpasswordController = TextEditingController();
TextEditingController usernameController = TextEditingController();
TextEditingController phoneController = TextEditingController();

Future<String?> login(
    String email, String password, BuildContext context) async {
  final url = Uri.parse('http://26.65.220.249:3023/login');

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      String token = responseData['token'];

      // Set the token using Provider
      Provider.of<AuthProvider>(context, listen: false).setToken(token);

      return token;
    } else {
      print("Login failed: ${response.statusCode} - ${response.body}");
      return null;
    }
  } catch (e) {
    print("Error: $e");
    return null;
  }
}

Future<String?> register(String email, String name, String password,
    String phone, BuildContext context) async {
  final url = Uri.parse('http://26.65.220.249:3023/register');

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "phone": phone,
        "name": name,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      String token = responseData['token'];

      // Set the token using Provider
      Provider.of<AuthProvider>(context, listen: false).setToken(token);

      return token;
    } else {
      print("Register failed: ${response.statusCode} - ${response.body}");
      return null;
    }
  } catch (e) {
    print("Error: $e");
    return null;
  }
}

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    if (authProvider.token != null) {
      // Navigate to the next screen if the token exists
      Future.microtask(
          () => Navigator.pushReplacementNamed(context, "/allitem"));
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Color(0xFFF8F4E1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _showBottomSheet(context, isSignUp: false),
              child: Text("SIGN IN"),
            ),
            ElevatedButton(
              onPressed: () => _showBottomSheet(context, isSignUp: true),
              child: Text("SIGN UP"),
            ),
          ],
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context, {required bool isSignUp}) {
    // Show bottom sheet for login/signup
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Color(0xFFAF8F6F),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isSignUp ? 'Sign Up' : 'Sign In',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFFFFFF),
                ),
              ),
              SizedBox(height: 20),
              if (isSignUp)
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              if (isSignUp) const SizedBox(height: 10),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              if (isSignUp) SizedBox(height: 10),
              if (isSignUp)
                TextField(
                  controller: confirmpasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              if (isSignUp) SizedBox(height: 10),
              if (isSignUp)
                TextField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFF8F4E1),
                  padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () async {
                  if (isSignUp) {
                    String email = emailController.text;
                    String name = usernameController.text;
                    String phone = phoneController.text;
                    String password = passwordController.text;
                    String confirmpass = confirmpasswordController.text;
                    if (password == confirmpass) {
                      await register(email, name, password, phone, context);
                      Navigator.pushNamed(context, "/login");
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Password mismatch!"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  } else {
                    String email = emailController.text;
                    String password = passwordController.text;

                    String? token = await login(email, password, context);
                    if (token != null) {
                      Navigator.pushNamed(context, "/allitem");
                      print("Login successful! Token: $token");
                    } else {
                      print("Login failed.");
                    }
                  }
                },
                child: Text(
                  isSignUp ? 'SIGN UP' : 'SIGN IN',
                  style: TextStyle(
                    color: Color(0xFF543310),
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
