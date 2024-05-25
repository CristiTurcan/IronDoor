import 'package:flutter/material.dart';
import 'package:iron_door/utils/error_dialog.dart';
import 'package:iron_door/utils/mybutton.dart';
import 'package:iron_door/utils/name_form.dart';
import 'package:iron_door/utils/unlock_function.dart';
import 'package:iron_door/utils/upload_photo.dart';

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
          child: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                MyButton(
                  title: 'Unlock',
                  function: () => unlock(),
                ),
              ]),
              const SizedBox(height: 15),
              NameForm(),
              const SizedBox(height: 15),
              MyButton(
                title: 'Upload photos',
                function: () async {
                  try {
                    await uploadPhotosToDatabase();
                  } catch (e) {
                    ShowErrorDialog.show(context, e.toString());
                  }
                },
              ),
            ],
          ),
        )
      ],
    );
  }
}
