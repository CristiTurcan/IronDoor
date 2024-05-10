import 'package:flutter/material.dart';
import 'package:iron_door/pages/history_content.dart';
import 'package:iron_door/utils/main_scaffold.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final List<String> items = [
    'John Smith has entered the house',
    "Door has been locked",
    "Door has been unlocked",
    "Someone tried to break in"
    ];

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
        widget: Column(
      children: [HistoryContent(items: items)],
    ));
  }
}
