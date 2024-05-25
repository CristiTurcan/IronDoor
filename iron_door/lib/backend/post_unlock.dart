import 'package:http/http.dart' as http;

const String ip = 'http://192.168.1.107:3000/embedded/unlock';

Future<http.Response> unlockDoor() {
  return http.post(Uri.parse(ip));
}
