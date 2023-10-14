import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:ksica/config.dart';

Future<Response> signInWithEmailAndPassword(
    String email, String password) async {
  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Accept": "application/json"
  };

  final url = Uri.parse('$SERVER_URL/auth/');
  try {
    final response = await post(
      url,
      body: json.encode({"email": email, "password": password}),
      headers: headers,
    );
    if (response.statusCode != 200) {
      print('Request failed with status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw HttpException(
          json.decode(utf8.decode(response.bodyBytes))["detail"]);
    }
    return response;
  } catch (e) {
    print("Error ocurred: $e");
    rethrow;
  }
}

Future<void> createUserWithEmailAndPassword(
    String email, String userName, String password) async {
  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Accept": "application/json"
  };

  final url = Uri.parse('$SERVER_URL/user/');
  try {
    final response = await post(
      url,
      body: json.encode(
        {
          "email": email,
          "username": userName,
          "password": password,
        },
      ),
      headers: headers,
    );
    if (response.statusCode != 200) {
      print('Request failed with status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw HttpException(
          json.decode(utf8.decode(response.bodyBytes))["detail"]);
      // throw Exception
    }
  } catch (e) {
    print("Error ocurred: $e");
    rethrow;
  }
}

Future<dynamic> signInWithToken() async {
  const storage = FlutterSecureStorage();
  String? token = await storage.read(key: "Authorization");
  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": token.toString(),
  };

  final url = Uri.parse("$SERVER_URL/auth/token");
  try {
    final response = await get(url, headers: headers);
    if (response.statusCode == 200) {
      Map<String, dynamic> decodedResposne = json.decode(response.body);
      return decodedResposne;
    } else {
      print('Request failed with status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception("Authentication failed");
    }
  } catch (e) {
    print("Error occured: $e");
    throw Exception("Authentication failed");
  }
}
