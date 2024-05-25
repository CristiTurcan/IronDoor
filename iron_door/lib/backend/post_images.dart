import 'package:iron_door/backend/url_file.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';

const String url = '$baseURL/face/enroll';

Future sendImages(String imageJSON) async {
  final response = await http.post(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
    },
    body: imageJSON,
  );

  if (response.statusCode == 200) {
    // If the server returns an OK response, print the response body
    log('Data sent successfully: status code: ${response.statusCode}');
    log('Response data: ${response.body}');
  } else {
    // If the server did not return a 200 OK response,
    // throw an exception.
    log("Error sending images: StatusCode: ${response.statusCode}");
    throw Exception('Failed to post data');
  }

  return response;
}
