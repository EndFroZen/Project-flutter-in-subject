import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SwapDetailScreen(),
    );
  }
}

class SwapDetailScreen extends StatefulWidget {
  @override
  _SwapDetailScreenState createState() => _SwapDetailScreenState();
}

class _SwapDetailScreenState extends State<SwapDetailScreen> {
  final Map<String, String> itemData = {
    'userItem': 'images/ball1.jpg', // Replace with your backend data
    'swapItem': 'images/ball1.jpg', // Replace with your backend data
  };

  int confirmationStep = 0; // Track the current confirmation step

  void _showAddressDialog() {
    final TextEditingController addressController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text('ใส่ข้อมูลที่อยู่ของคุณ'),
          content: TextField(
            controller: addressController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'ใส่ข้อมูลที่อยู่ของคุณ',
            ),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('ยกเลิก'),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle address submission
                String enteredAddress = addressController.text;
                print('Address: $enteredAddress');
                Navigator.of(context).pop();
              },
              child: Text('ตกลง'),
            ),
          ],
        );
      },
    );
  }

  void _confirmAction() {
    setState(() {
      confirmationStep = 1; // Update to 1/2 immediately
    });
    _showAddressDialog(); // Show address dialog after updating step
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF543310),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Swap's detail",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // User's item
                        Image.asset(
                          itemData['userItem']!,
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                        Icon(
                          Icons.swap_horiz,
                          size: 40,
                          color: Colors.grey,
                        ),
                        // Swap item
                        Image.asset(
                          itemData['swapItem']!,
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  // Confirmation step
                  Text(
                    'การยืนยัน $confirmationStep/2',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          // Confirm button with square background
          Container(
            color: Color(0xFF543310),
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: GestureDetector(
                onTap: _confirmAction, // Perform confirmation and show dialog
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Color(0xFF74512D),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.check,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Color(0xFFF8F4E1),
    );
  }
}
