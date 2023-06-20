import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

Future<Response> signInWithEmailAndPassword(
    String email, String password) async {
  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Accept": "application/json"
  };

  final url = Uri.parse('http://141.164.51.245:8000/auth/');
  final response = await http.post(
    url,
    body: json.encode({"email": email, "password": password}),
    headers: headers,
  );
  return response;
}

Future<void> createUserWithEmailAndPassword(
    String email, String userName, String password) async {
  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Accept": "application/json"
  };

  final url = Uri.parse('http://141.164.51.245:8000/user/');
  final response = await http.post(
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
}
