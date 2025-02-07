import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  const BottomNavBar({Key? key, required this.currentIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed, // ให้ไอคอนอยู่ตำแหน่งเดิมเสมอ
      backgroundColor: Color(0xFF543310), // สีน้ำตาลเข้มตามภาพ
      selectedItemColor: Colors.white, // สีไอคอนที่เลือก
      unselectedItemColor: Colors.white70, // สีไอคอนที่ไม่ได้เลือก
      showSelectedLabels: false, // ซ่อน label
      showUnselectedLabels: false, // ซ่อน label
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(context, "/home");
            break;
          case 1:
            Navigator.pushReplacementNamed(context, "/swap");
            break;
          case 2:
            Navigator.pushReplacementNamed(context, "/profile");
            break;
          case 3:
            Navigator.pushReplacementNamed(context, "/search");
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home, size: 28),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.compare_arrows, size: 28),
          label: 'Trade',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person, size: 28),
          label: 'Profile',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search, size: 28),
          label: 'Search',
        ),
      ],
    );
  }
}
