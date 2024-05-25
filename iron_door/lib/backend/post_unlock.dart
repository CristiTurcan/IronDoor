import 'package:iron_door/backend/url_file.dart';
import 'package:http/http.dart' as http;

const String url = '$baseURL/embedded/unlock';

Future<http.Response> unlockDoor() {
  return http.post(Uri.parse(url));
}
