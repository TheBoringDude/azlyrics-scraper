import 'package:http/http.dart' as http;

Future<String> requester(String url) async {
  final uri = Uri.parse(url);
  final r = await http.get(uri);

  return r.body;
}
