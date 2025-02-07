import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:http/http.dart' as http;
import 'package:main/AuthProvider.dart';
import 'dart:convert';
import 'package:provider/provider.dart';

TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();
TextEditingController confirmpasswordController = TextEditingController();
TextEditingController usernameController = TextEditingController();
TextEditingController phoneController = TextEditingController();

Future<String?> login(
    BuildContext context, String email, String password) async {
  final url = Uri.parse('http://26.65.220.249:3023/login');

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      String token = responseData['token'];
      Provider.of<AuthProvider>(context, listen: false).setToken(token);

      // Navigate to the next screen
      Navigator.pushReplacementNamed(context, "/allitem");
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

Future<void> register(BuildContext context, String email, String name,
    String password, String phone) async {
  final url = Uri.parse('http://26.65.220.249:3023/register');

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
      home: AuthScreen(),
      // routes: {"/allitem": (context) => AllItem()},
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
    // หากไม่มี token ให้แสดงหน้าจอ login/signup
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
                      padding:
                          const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      side: const BorderSide(color: Color(0xFF543310), width: 1),
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
                      padding:
                          const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
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
    // แสดงหน้าจอ BottomSheet สำหรับ Login หรือ SignUp
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
                    labelText: 'confirm Password',
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
                  padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
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
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("รหัสผ่านไม่ตรงกัน!"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                    Navigator.pushNamed(context, "/login");
                  } else {
                    String email = emailController.text;
                    String password = passwordController.text;

                    String? token = await login(context, email, password);
                    Navigator.pushNamed(context, "/allitem");
                    if (token != null) {
                      print("Login successful! Token: $token");
                    } else {
                      print("Login failed.");
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
