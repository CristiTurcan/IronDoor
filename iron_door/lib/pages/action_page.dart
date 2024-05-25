import 'package:flutter/material.dart';
import 'package:iron_door/utils/doorbutton.dart';
import 'package:iron_door/utils/unlock_function.dart';

class MyActions extends StatefulWidget {
  const MyActions({super.key});

  @override
  State<MyActions> createState() => _MyActionsState();
}

class _MyActionsState extends State<MyActions> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DoorButton(
                title: 'Unlock',
                function: () => unlock(),
              ),
            ],
          ),
        )
      ],
    );
  }
}
