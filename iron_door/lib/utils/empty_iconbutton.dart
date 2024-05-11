import 'package:flutter/material.dart';

// this is used to keep text centered in history content list

class EmptyIconButton extends StatelessWidget {
  const EmptyIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return const IconButton(
      icon: Icon(
        Icons.photo, // Using a transparent icon
        color: Colors.transparent, // Making the icon color transparent
      ),
      onPressed: null, // Disabling onPressed callback
    );
  }
}
