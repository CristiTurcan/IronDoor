import 'package:flutter/material.dart';
import 'package:iron_door/pages/action_page.dart';
import 'package:iron_door/utils/main_scaffold.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return const MainScaffold(widget: MyActions());
  }
}
