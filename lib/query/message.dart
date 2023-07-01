import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../config.dart';

Future<List<Map<String, dynamic>>> fetchMessages(int chatroomId) async {
  const storage = FlutterSecureStorage();
  String? token = await storage.read(key: "Authorization");
  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": token.toString(),
  };

  final url = Uri.parse("$SERVER_URL/message/$chatroomId");
  final response = await http.get(url, headers: headers);
  List<dynamic> decodedResposne = json.decode(response.body);
  List<Map<String, dynamic>> messages =
      decodedResposne.cast<Map<String, dynamic>>().toList();
  print(messages);
  return messages;
}
