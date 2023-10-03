import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
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

  final url = Uri.parse("$SERVER_URL/profile/");
  await http.post(
    url,
    body: json.encode(checkStates),
    headers: headers,
  );
}

Future<Uint8List> fetchProfileImage([int? userId]) async {
  const storage = FlutterSecureStorage();
  String? token = await storage.read(key: "Authorization");
  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": token.toString(),
  };

  final url = userId == null
      ? Uri.parse("$SERVER_URL/profile")
      : Uri.parse("$SERVER_URL/profile/id/$userId");
  final response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    return response.bodyBytes;
  } else {
    throw Exception("Profile image not found");
  }
}

Future<void> uploadProfileImage(File image) async {
  const storage = FlutterSecureStorage();
  String? token = await storage.read(key: "Authorization");

  var url = Uri.parse("$SERVER_URL/profile/");

  var request = http.MultipartRequest('POST', url);
  request.files.add(await http.MultipartFile.fromPath('file', image.path));
  request.headers["Authorization"] = token.toString();
  var response = await request.send();

  if (response.statusCode == 200) {
    print('File uploaded successfully');
  } else {
    print('Failed to upload file. Error: ${response.reasonPhrase}');
  }
}

Future<void> updateProfileImage(File image) async {
  const storage = FlutterSecureStorage();
  String? token = await storage.read(key: "Authorization");

  var url = Uri.parse("$SERVER_URL/profile/");

  var request = http.MultipartRequest('PATCH', url);
  request.files.add(await http.MultipartFile.fromPath('file', image.path));
  request.headers["Authorization"] = token.toString();
  var response = await request.send();

  if (response.statusCode == 200) {
    print('File uploaded successfully');
  } else {
    print('Failed to upload file. Error: ${response.reasonPhrase}');
  }
}

Future<void> deleteProfileImage() async {
  const storage = FlutterSecureStorage();
  String? token = await storage.read(key: "Authorization");
  Map<String, String> headers = {
    "Authorization": token.toString(),
  };

  var url = Uri.parse("$SERVER_URL/profile/");

  var response = await http.delete(url, headers: headers);

  if (response.statusCode == 200) {
    print('Data deleted successfully');
  } else {
    print('Failed to delete data. Error: ${response.reasonPhrase}');
  }
}
