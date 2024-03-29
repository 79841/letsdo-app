import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../config/url.dart';

Future<Map<String, dynamic>> fetchChatroom() async {
  const storage = FlutterSecureStorage();
  String? token = await storage.read(key: "Authorization");
  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": token.toString(),
  };

  final url = Uri.parse("$SERVER_URL/chatroom");
  final response = await http.get(url, headers: headers);
  dynamic decodedResposne = json.decode(response.body);
  Map<String, dynamic> chatroom = decodedResposne ?? {};
  return chatroom;
}

Future<dynamic> createChatroom() async {
  const storage = FlutterSecureStorage();
  String? token = await storage.read(key: "Authorization");
  Map<String, String> headers = {
    "Accept": "application/json",
    "Authorization": token.toString(),
  };

  final url = Uri.parse("$SERVER_URL/chatroom/");
  try {
    final response = await http.post(url, headers: headers);
    if (response.statusCode == 200) {
      dynamic decodedResposne = json.decode(response.body);
      Map<String, dynamic> chatroom = decodedResposne;
      return chatroom;
    } else {
      print('Request failed with status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw HttpException(
          json.decode(utf8.decode(response.bodyBytes))["detail"]);
    }
  } catch (e) {
    rethrow;
  }
}

Future<dynamic> fetchOpponent(int chatroomId) async {
  const storage = FlutterSecureStorage();
  String? token = await storage.read(key: "Authorization");
  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": token.toString(),
  };

  final url = Uri.parse("$SERVER_URL/chatroom/opponent/$chatroomId");
  try {
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      Map<String, dynamic> decodedResposne = json.decode(response.body);
      return decodedResposne;
    } else {
      print('Request failed with status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (e) {
    print("Error occured: $e");
  }
}
