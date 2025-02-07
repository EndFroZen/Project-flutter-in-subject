import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TradeScreen(),
    );
  }
}

class TradeScreen extends StatefulWidget {
  const TradeScreen({super.key});

  @override
  _TradeScreenState createState() => _TradeScreenState();
}

class _TradeScreenState extends State<TradeScreen> {
  final List<Map<String, String>> items = [
    {'image': 'images/ball1.jpg', 'name': 'Item 1'},
    {'image': 'images/ball1.jpg', 'name': 'Item 2'},
    {'image': 'images/ball1.jpg', 'name': 'Item 3'},
    {'image': 'images/ball1.jpg', 'name': 'Item 4'},
    {'image': 'images/ball1.jpg', 'name': 'Item 5'},
    {'image': 'images/ball1.jpg', 'name': 'Item 6'},
  ];

  String? selectedImage; // เก็บภาพที่เลือก

  void _showImageOverlay() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.5,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                width: 100,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedImage = item['image']; // บันทึกภาพที่เลือก
                        });
                        Navigator.pop(context); // ปิด overlay
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: AssetImage(item['image']!),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            color: Colors.black.withOpacity(0.5),
                            child: Text(
                              item['name']!,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF543310),
        leading: IconButton(
          icon: const Icon(Icons.close, size: 40, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Trade', style: TextStyle(color: Color(0xFFF8F4E1))),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.check, size: 40, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: const Color(0xFF543310),
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Color(0xFFDDDDDD),
                    ),
                    SizedBox(height: 8),
                    Text('You', style: TextStyle(color: Colors.white)),
                  ],
                ),
                Text('แลกกับ',
                    style: TextStyle(color: Colors.white, fontSize: 16)),
                Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Color(0xFFDDDDDD),
                    ),
                    SizedBox(height: 8),
                    Text('Name', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey[300]),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          const Text('ไอเท็มที่แลก', style: TextStyle(fontSize: 16)),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: _showImageOverlay,
                            child: Container(
                              width: 140,
                              height: 140,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: selectedImage == null
                                  ? const Center(
                                      child: Icon(Icons.add,
                                          size: 40, color: Colors.grey),
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: Image.asset(
                                        selectedImage!,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                      const Column(
                        children: [
                          SizedBox(height: 72),
                          Icon(Icons.swap_horiz, size: 50, color: Colors.grey),
                        ],
                      ),
                      Column(
                        children: [
                          const SizedBox(height: 32),
                          Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              image: const DecorationImage(
                                image: AssetImage('images/ball1.jpg'),
                                fit: BoxFit.cover,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  offset: const Offset(0, 4),
                                  blurRadius: 6,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}
