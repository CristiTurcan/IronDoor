import 'package:flutter/material.dart';
import 'dart:developer';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Iron Door'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          SizedBox(
            child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DoorButton(title: 'Lock', function: () => {
                log('Locked')
              }),
              const SizedBox(width: 10),
              DoorButton(title: 'Unlock', function: () => {
                log('Unlocked')
              },),
            ],
          ),)
        ],
      ),
    );
  }
}


class DoorButton extends StatefulWidget {
  final String title;
  final VoidCallback function;

  const DoorButton({
    super.key,
    required this.title,
    required this.function,
    });

  @override
  State<DoorButton> createState() => _DoorButtonState();
}

class _DoorButtonState extends State<DoorButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 50,
      child: ElevatedButton(onPressed: widget.function, child: Text(widget.title)));
  }
}