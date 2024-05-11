import 'package:flutter/material.dart';
import 'package:iron_door/pages/history_content.dart';
import 'package:iron_door/utils/main_scaffold.dart';
import 'package:iron_door/utils/my_notification.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  // this is dummy example until connecting to db and everything else :)
  final List<String> items = [
    "John Smith has entered the house",
    "Door has been locked",
    "Door has been unlocked",
    "Someone tried to break in",
    "Another example"
  ];

  final List<MyNotification> notifications = [
    MyNotification("John Smith has entered the house", false),
    MyNotification("Door has been locked", false),
    MyNotification("Door has been unlocked", false),
    MyNotification("Someone tried to break in", true),
    MyNotification("Another example", false)
  ];

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
        widget: Column(
      children: [HistoryContent(notifications: notifications)],
    ));
  }
}
