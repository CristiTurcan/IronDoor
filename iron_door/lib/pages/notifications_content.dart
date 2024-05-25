import 'package:flutter/material.dart';
import 'package:iron_door/utils/empty_iconbutton.dart';
import 'package:iron_door/backend/my_notification.dart';
import 'package:iron_door/backend/get_notification.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';

class NotificationsContent extends StatefulWidget {
  const NotificationsContent({super.key});

  @override
  State<NotificationsContent> createState() => _NotificationsContentState();
}

class _NotificationsContentState extends State<NotificationsContent> {
  late Future<List<MyNotification>> futureNotifications;

  @override
  void initState() {
    super.initState();
    futureNotifications = fetchNotification(http.Client());

    // printNotifications(futureNotifications);
  }

//   Future<void> printNotifications(futureNotifications) async {
//   // futureNotifications = fetchNotification(http.Client());
//   try {
//     final notifications = await futureNotifications;
//     log('Notifications: $notifications');
//   } catch (e) {
//     log('Error fetching notifications: $e');
//   }
// }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder<List<MyNotification>>(
        future: futureNotifications,
        builder: (context, snapshot) {
          if (snapshot.hasError && snapshot.error != null) {
            final errorMessage = snapshot.error;

            log('Error din snapshot: $errorMessage');
            return const Center(
              child: Text('An error has occurred!'),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final notification = snapshot.data![index];
                return ListTile(
                  leading: const EmptyIconButton(),
                  title: Text(notification.name, textAlign: TextAlign.center),
                  subtitle:
                      Text(notification.message, textAlign: TextAlign.center),
                  trailing: notification.hasImage > 0
                      ? IconButton(
                          icon: const Icon(Icons.photo),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: Image.network(notification
                                      .image), // Assuming image URL is used
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Close'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        )
                      : const EmptyIconButton(),
                );
              },
            );
          } else {
            return const Center(
              child: Text('No notifications found.'),
            );
          }
        },
      ),
    );
  }
}
