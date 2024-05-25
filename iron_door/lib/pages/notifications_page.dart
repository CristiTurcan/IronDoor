import 'package:flutter/material.dart';
import 'package:iron_door/pages/notifications_content.dart';
import 'package:iron_door/utils/main_scaffold.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    return const MainScaffold(
        widget: Column(
      children: [NotificationsContent()],
    ));
  }
}
