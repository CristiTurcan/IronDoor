import 'package:flutter/material.dart';

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