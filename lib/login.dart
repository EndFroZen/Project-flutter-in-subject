import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:http/http.dart' as http;
import 'package:main/AuthProvider.dart';
import 'package:main/allitem.dart';
import 'dart:convert';
import 'package:provider/provider.dart';

TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();
TextEditingController confirmpasswordController = TextEditingController();
TextEditingController usernameController = TextEditingController();
TextEditingController phoneController = TextEditingController();

Future<String?> login(
    BuildContext context, String email, String password) async {
  final url = Uri.parse('https://arther.bxoks.online/login');

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      String token = responseData['token'];
      Provider.of<AuthProvider>(context, listen: false).setToken(token);

      Navigator.pushReplacementNamed(context, "/allitem");
      return token;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Email or password is invalid!"),
          backgroundColor: Colors.red,
        ),
      );
      return null;
    }
  } catch (e) {
    print("Error: $e");
    return null;
  }
}

Future<void> register(BuildContext context, String email, String name,
    String password, String phone) async {
  final url = Uri.parse('https://arther.bxoks.online/register');

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "phone": phone,
        "name": name,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      Navigator.pushReplacementNamed(context, "/allitem");
    } else {
      print("Login failed: ${response.statusCode} - ${response.body}");
      return;
    }
  } catch (e) {
    print("Error: $e");
    return;
  }
}

class Loginpage extends StatelessWidget {
  const Loginpage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthScreen(),
      routes: {
        '/login': (context) => const Loginpage(),
        '/allitem': (context) =>
            const AllItem(), // Define your AllItem screen here
      },
    );
  }
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  String? token;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F4E1),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: DottedBorder(
          color: Colors.black,
          strokeWidth: 6,
          dashPattern: const [10, 4],
          borderType: BorderType.RRect,
          radius: const Radius.circular(12),
          child: DecoratedBox(
            decoration: const BoxDecoration(
              color: Color(0xFFF8F4E1),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'TradeOn',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF543310),
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 60, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      side:
                          const BorderSide(color: Color(0xFF543310), width: 1),
                    ),
                    onPressed: () {
                      _showBottomSheet(context, isSignUp: false);
                    },
                    child: const Text(
                      'SIGN IN',
                      style: TextStyle(
                        color: Color(0xFF543310),
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF543310),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 60, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      _showBottomSheet(context, isSignUp: true);
                    },
                    child: const Text(
                      'SIGN UP',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context, {required bool isSignUp}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFAF8F6F),
      shape: const RoundedRectangleBorder(
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
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFFFFFF),
                ),
              ),
              const SizedBox(height: 20),
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
              const SizedBox(height: 10),
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
              if (isSignUp) const SizedBox(height: 10),
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
              if (isSignUp) const SizedBox(height: 10),
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
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF8F4E1),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
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
                      await register(context, email, name, password, phone);
                      Navigator.pushNamed(context, "/login");
                    } else {
                      showErrorDialog(context, "Register fial", "Password doesn't match!");
                    }
                  } else {
                    String email = emailController.text;
                    String password = passwordController.text;

                    String? token = await login(context, email, password);
                    if (token != null) {
                      Navigator.pushNamed(context, "/allitem");
                      print("Login successful! Token: $token");
                    } else {
                      showErrorDialog(context, "Login Failed", "Email or Password invalid plase try again!");
                    }
                  }
                },
                child: Text(
                  isSignUp ? 'SIGN UP' : 'SIGN IN',
                  style: const TextStyle(
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
void showErrorDialog(BuildContext context, String title, String message) {
  showAdaptiveDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: Colors.white,
        title: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 28),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Text("OK", style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      );
    },
  );
}