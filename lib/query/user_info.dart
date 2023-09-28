import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ksica/config.dart';
import 'package:http/http.dart' as http;

Future<dynamic> updateUserInfo(Map userInfo) async {
  const storage = FlutterSecureStorage();
  String? token = await storage.read(key: "Authorization");
  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": token.toString(),
  };

  final url = Uri.parse("$SERVER_URL/user/");
  try {
    final response = await http.patch(
      url,
      body: json.encode(userInfo),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return {"updated": true};
    } else {
      print('Request failed with status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      return {"updated": false};
    }
  } catch (e) {
    print("Error occured: $e");
  }
}

Future<dynamic> getUserInfo() async {
  const storage = FlutterSecureStorage();
  String? token = await storage.read(key: "Authorization");
  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": token.toString(),
  };
  final url = Uri.parse("$SERVER_URL/user/");
  try {
    final response = await http.get(
      url,
      headers: headers,
    );

    if (response.statusCode == 200) {
      dynamic decodedResposne = json.decode(response.body);
      Map<String, dynamic> userInfo = decodedResposne;
      return userInfo;
    } else {
      print('Request failed with status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      return {"updated": false};
    }
  } catch (e) {
    print("Error occured: $e");
  }
}
