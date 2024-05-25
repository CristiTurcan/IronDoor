import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // const DrawerHeader(
          //   decoration: BoxDecoration(
          //     color: Colors.blue,
          //   ),
          //   child: Text(
          //     'Drawer Header',
          //     style: TextStyle(
          //       color: Colors.white,
          //       fontSize: 24,
          //     ),
          //   ),
          // ),
          const SizedBox(height: 30,),
          ListTile(
            leading: const Icon(Icons.message),
            title: const Text('Home'),
            onTap: () {
              Navigator.pushNamed(context, '/homepage');
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('Notifications'),
            onTap: () {
              Navigator.pushNamed(context, '/notificationspage');
            },
          ),
        ],
      ),
    );
  }
}
