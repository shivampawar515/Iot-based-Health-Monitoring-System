import 'package:http/http.dart' as http;

Future Getdata(url) async {
  final http.Response response = await http.get(url);
  return response.body;
}
