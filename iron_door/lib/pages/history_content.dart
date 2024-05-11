import 'package:flutter/material.dart';
import 'package:iron_door/utils/empty_iconbutton.dart';
import 'package:iron_door/utils/my_notification.dart';

class HistoryContent extends StatefulWidget {
  final List<MyNotification> notifications;
  const HistoryContent({super.key, required this.notifications});

  @override
  State<HistoryContent> createState() => _HistoryContentState();
}

class _HistoryContentState extends State<HistoryContent> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
          itemCount: widget.notifications.length,
          separatorBuilder: (context, index) {
            return const Divider(
              color: Colors.grey,
              thickness: 1.0,
              height: 0.0,
            );
          },
          itemBuilder: (context, index) {
            return ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const EmptyIconButton(),
                  Expanded(
                    child: Text(
                      widget.notifications[index].message,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  if (widget.notifications[index].hasImage)
                    IconButton(
                      icon: const Icon(Icons.photo),
                      onPressed: () => {
                        showDialog(
                            context: context,
                            builder: ((context) {
                              return AlertDialog(
                                content:
                                    Image.asset('assets/images/person.jpeg'),
                                actions: [
                                  TextButton(
                                      onPressed: () => {
                                            Navigator.of(context).pop(),
                                          },
                                      child: const Text('Close'))
                                ],
                              );
                            }))
                      },
                    )
                  else
                    const EmptyIconButton()
                ],
              ),
            );
          }),
    );
  }
}
