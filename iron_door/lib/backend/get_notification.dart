import 'package:iron_door/backend/my_notification.dart';
import 'package:iron_door/backend/url_file.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const String url = '$baseURL/notifications';

List<MyNotification> parseNotifications(String responseBody) {
  final parsed = jsonDecode(responseBody) as List<dynamic>;
  return parsed
      .map<MyNotification>((json) => MyNotification.fromJson(json))
      .toList();
}

Future<List<MyNotification>> fetchNotification(http.Client client) async {
  try {
    final response =
        await client.get(Uri.parse(url)).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      return compute(parseNotifications, response.body);
    } else {
      throw HttpException(
          'Failed to load notifications: ${response.statusCode}');
    }
  } catch (e) {
    throw FetchDataException('Error fetching notifications: $e');
  }
}

class HttpException implements Exception {
  final String message;

  HttpException(this.message);

  @override
  String toString() => 'HttpException: $message';
}

class FetchDataException implements Exception {
  final String message;

  FetchDataException(this.message);

  @override
  String toString() => 'FetchDataException: $message';
}
