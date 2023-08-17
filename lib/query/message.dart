import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../config.dart';

const String apiPrefix = "message";

Future<List<Map<String, dynamic>>> fetchMessages(int chatroomId) async {
  const storage = FlutterSecureStorage();
  String? token = await storage.read(key: "Authorization");
  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": token.toString(),
  };

  final url = Uri.parse("$SERVER_URL/$apiPrefix/$chatroomId");
  final response = await http.get(url, headers: headers);
  List<dynamic> decodedResponse = json.decode(utf8.decode(response.bodyBytes));
  List<Map<String, dynamic>> messages =
      decodedResponse.cast<Map<String, dynamic>>().toList();
  return messages;
}

Future<Map<String, dynamic>> updateLastReadMessage(
    int chatroomId, int messageId) async {
  const storage = FlutterSecureStorage();
  String? token = await storage.read(key: "Authorization");
  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": token.toString(),
  };
  final url = Uri.parse(
      "$SERVER_URL/$apiPrefix/last/read/$chatroomId?message_id=$messageId");
  final response = await http.patch(url, headers: headers);
  dynamic decodedResponse = json.decode(response.body);
  Map<String, dynamic> message = decodedResponse.cast<String, dynamic>();

  return message;
}

Future<int> getUnreadMessageCount(int chatroomId) async {
  const storage = FlutterSecureStorage();
  String? token = await storage.read(key: "Authorization");
  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": token.toString(),
  };
  final url = Uri.parse("$SERVER_URL/$apiPrefix/unread/count/$chatroomId");
  final response = await http.get(url, headers: headers);
  dynamic decodedResponse = json.decode(response.body);
  int unreadMessageCount = int.parse(decodedResponse);

  return unreadMessageCount;
}
