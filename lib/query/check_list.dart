import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../config.dart';

Future<void> updateCheckList(checkStates) async {
  const storage = FlutterSecureStorage();
  String? token = await storage.read(key: "Authorization");
  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": token.toString(),
  };

  final url = Uri.parse("$SERVER_URL/checklist/");
  await http.post(
    url,
    body: json.encode(checkStates),
    headers: headers,
  );
}

Future<dynamic> fetchCheckList() async {
  const storage = FlutterSecureStorage();
  String? token = await storage.read(key: "Authorization");
  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": token.toString(),
  };

  final url = Uri.parse("$SERVER_URL/checklist/");
  final response = await http.get(url, headers: headers);
  return json.decode(response.body);
}
