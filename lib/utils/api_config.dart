import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

Future<Map<String, dynamic>?> apiCallback({
  Map<String, String>? header,
  required String url,
  Map? body,
  String? method = 'POST',
}) async {
  try {
    http.Response res;
    switch (method) {
      case 'POST':
        res = await http.post(
          headers: header,
          Uri.parse(url),
          body: body,
        );
        break;
      default:
        res = await http.get(
          headers: header,
          Uri.parse(url),
        );
    }

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    return null;
  } catch (e) {
    log("Error in API - $e");
  }
  return null;
}
