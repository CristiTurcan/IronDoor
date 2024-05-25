import 'package:flutter/material.dart';

class ShowErrorDialog extends StatelessWidget {
  final String message;

  const ShowErrorDialog({required this.message, super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Error'),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }

  static void show(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => ShowErrorDialog(message: message),
    );
  }
}
