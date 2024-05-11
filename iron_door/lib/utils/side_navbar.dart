// Made this but won t be using it

import 'package:flutter/material.dart';
import 'package:iron_door/pages/action_page.dart';
import 'package:iron_door/pages/history_page.dart';
import 'package:side_navigation/side_navigation.dart';

class MySideNavBar extends StatefulWidget {
  const MySideNavBar({super.key});

  @override
  State<MySideNavBar> createState() => _MySideNavBarState();
}

class _MySideNavBarState extends State<MySideNavBar> {
  List pages = [const MyActions(), const HistoryPage()];
  int selectedIndex = 0;

  void onTap(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SideNavigationBar(
            selectedIndex: selectedIndex,
            items: const [
              SideNavigationBarItem(icon: Icons.home, label: 'Home'),
              SideNavigationBarItem(
                  icon: Icons.hourglass_empty, label: 'History')
            ],
            onTap: onTap),
        Expanded(child: pages.elementAt(selectedIndex))
      ],
    );
  }
}
