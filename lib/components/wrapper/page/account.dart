import 'package:flutter/material.dart';

class Account extends StatelessWidget {
  const Account({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Account"),
      ),
      body: Column(
        children: [
          Container(
            height: 180, // ความสูง 180
            width: double.infinity, // ความกว้างเต็มจอ
            color: const Color(0xFF222831), // สีพื้นหลัง
            child: Center(
                child: ClipOval(
              child: Image.network(
                "http://10.50.18.116:4050/api/image/shimp.jpg",
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            )),
          ),
          Container(
            height: 180,
            width: double.infinity,
            color: const Color.fromARGB(255, 255, 3, 32),
            child: const Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Name",
                        style: TextStyle(fontSize: 23),
                      ),
                      Text(
                        "Data",
                        style: TextStyle(fontSize: 23),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Name",
                        style: TextStyle(fontSize: 23),
                      ),
                      Text(
                        "Data",
                        style: TextStyle(fontSize: 23),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Name",
                        style: TextStyle(fontSize: 23),
                      ),
                      Text(
                        "Data",
                        style: TextStyle(fontSize: 23),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
