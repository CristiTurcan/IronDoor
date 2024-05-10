import 'package:flutter/material.dart';
import 'package:iron_door/utils/drawer.dart';

class MainScaffold extends StatefulWidget {
  final Widget widget;

  const MainScaffold({super.key, required this.widget});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Iron Door"),
      ),
      drawer: const MyDrawer(),
      body: widget.widget,
    );
  }
}