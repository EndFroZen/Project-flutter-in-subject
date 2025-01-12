import 'dart:convert';

import 'package:flutter/material.dart';

class Maindrawer extends StatelessWidget {
  const Maindrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const UserAccountsDrawerHeader(
              accountName: Text("data"), accountEmail: Text("hello")),
          listnavi(context, Icons.sync_alt, "/trade", "Trade"),
          listnavi(
              context, Icons.notifications, "/Notification", "Notification"),
          listnavi(context, Icons.person, "/accoute", "Accounts"),
          listnavi(context, Icons.settings, "/setting", "Setting"),
          listnavi(context, Icons.logout_outlined, "/logout", "Log out"),
        ],
      ),
    );
  }
}

Widget listnavi(context, icon, link, name) {
  return InkWell(
    onTap: () {
      Navigator.pushNamed(context, link);
    },
    child: Container(
        height: 60,
        child: Row(
          children: [
            const SizedBox(
              width: 15,
            ),
            Icon(
              icon,
              size: 30,
              color: Colors.black.withOpacity(0.7),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              name,
              style: TextStyle(
                fontSize: 20,
                color: Colors.black.withOpacity(0.7),
              ),
            ),
          ],
        )),
  );
}
