import 'package:flutter/material.dart';

class MyButton extends StatefulWidget {
  final String title;
  final VoidCallback function;

  const MyButton({
    super.key,
    required this.title,
    required this.function,
    });

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 50,
      child: ElevatedButton(onPressed: widget.function, child: Text(widget.title, textAlign: TextAlign.center)));
  }
}