import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ksica/config.dart';
import 'package:http/http.dart' as http;

Future<dynamic> updateProfile(Map profile) async {
  const storage = FlutterSecureStorage();
  String? token = await storage.read(key: "Authorization");
  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": token.toString(),
  };

  final url = Uri.parse("$SERVER_URL/user/");
  final response = await http.patch(
    url,
    body: json.encode(profile),
    headers: headers,
  );
  return response;
}
