import 'package:flutter/material.dart';
import 'package:iron_door/utils/upload_photo.dart';

class NameForm extends StatefulWidget {
  @override
  _NameFormState createState() => _NameFormState();
}

class _NameFormState extends State<NameForm> {
  final TextEditingController _nameController = TextEditingController();
  String? enteredName;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_updateEnteredName);
  }

  @override
  void dispose() {
    _nameController.removeListener(_updateEnteredName);
    _nameController.dispose();
    super.dispose();
  }

  void _updateEnteredName() {
    setState(() {
      if (uploadPressed) {
        _nameController.clear();
        uploadPressed = false;
      }
      enteredName = _nameController.text.trim();
      setName(enteredName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Enter name, then upload photos:',
              style: TextStyle(fontSize: 16.0),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8.0),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Enter your name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
