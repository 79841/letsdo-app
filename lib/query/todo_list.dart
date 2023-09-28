import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config.dart';

Future<List<dynamic>> fetchTodoList() async {
  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Accept": "application/json"
  };

  final url = Uri.parse("$SERVER_URL/todolist/");
  final response = await http.get(url, headers: headers);
  return json.decode(response.body);
}
