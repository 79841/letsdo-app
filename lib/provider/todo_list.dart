import 'dart:async';
import 'package:flutter/material.dart';

import '../query/todo_list.dart';

class TodoList with ChangeNotifier {
  List<dynamic> _todoList = [];
  List<dynamic> get todoList => _todoList;

  Future<void> getTodoList() async {
    // Map<String, String> headers = {
    //   "Content-Type": "application/json",
    //   "Accept": "application/json"
    // };

    // final url = Uri.parse("$SERVER_URL/todolist/");
    // final response = await http.get(url, headers: headers);

    _todoList = await fetchTodoList();
    notifyListeners();
  }
}
