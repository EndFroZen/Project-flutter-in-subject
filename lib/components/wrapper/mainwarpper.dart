import 'package:flutter/material.dart';
import 'package:project/components/wrapper/page/account.dart';
import 'package:project/components/wrapper/page/maintrade.dart';

class Mainwarpper extends StatefulWidget {
  const Mainwarpper({super.key});

  @override
  State<Mainwarpper> createState() => _MainwarpperState();
}

class _MainwarpperState extends State<Mainwarpper> {
  int _selectindex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectindex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectindex = index;
          });
        },
        destinations: const <NavigationDestination>[
          NavigationDestination(
            selectedIcon: Icon(Icons.public),
            icon: Icon(Icons.public),
            label: "Home",
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.sync_alt),
            icon: Icon(Icons.sync_alt),
            label: "Trade",
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.notifications),
            icon: Icon(Icons.notifications),
            label: "Notification",
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.person),
            icon: Icon(Icons.person),
            label: "Account",
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectindex,
        children: const [
          Maintrade(),
          Account(),
        ],
      ),
    );
  }
}
