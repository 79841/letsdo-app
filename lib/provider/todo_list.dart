import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../config.dart';
import 'package:http/http.dart' as http;

class TodoList with ChangeNotifier {
  List<dynamic> _todoList = [];
  List<dynamic> get todoList => _todoList;

  Future<void> initialize() async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Accept": "application/json"
    };

    final url = Uri.parse("$SERVER_URL/todolist/");
    final response = await http.get(url, headers: headers);

    _todoList = json.decode(response.body);
    notifyListeners();
  }
}
