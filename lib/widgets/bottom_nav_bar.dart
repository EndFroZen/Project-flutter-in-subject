import 'package:flutter/material.dart';
import 'package:main/AuthProvider.dart';
import 'package:main/allitem.dart';
import 'package:main/user.dart';
import 'package:provider/provider.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  const BottomNavBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color(0xFF543310),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      onTap: (index) {
        if (index != currentIndex) {
          // ป้องกันการนำทางซ้ำซ้อน
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AllItem()),
              );
              break;
            case 1:
              Navigator.pushReplacementNamed(context, "/swap");
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => User(
                          authToken: '$token',
                        )),
              );
              break;
            case 3:
              Navigator.pushReplacementNamed(context, "/search");
              break;
          }
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
          label: 'User',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search, size: 28),
          label: 'Search',
        ),
      ],
    );
  }
}
