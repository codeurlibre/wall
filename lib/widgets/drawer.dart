import 'package:flutter/material.dart';

import 'my_list_tile.dart';

class MyDrawer extends StatelessWidget {
  final void Function() onProfilTap;
  final void Function() onSignOut;
  const MyDrawer(
      {super.key, required this.onProfilTap, required this.onSignOut});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[900],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const DrawerHeader(
                  child: Icon(
                Icons.person,
                color: Colors.white,
                size: 64,
              )),
              MyListTile(
                icon: Icons.home,
                text: "Home",
                onTap: () => Navigator.pop(context),
              ),
              MyListTile(
                  icon: Icons.person, text: "profile", onTap: onProfilTap),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 25.0),
            child: MyListTile(
                icon: Icons.logout, text: "logout", onTap: onSignOut),
          ),
        ],
      ),
    );
  }
}
