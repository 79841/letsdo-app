import 'dart:async';
import 'package:flutter/material.dart';

import '../query/todo_list.dart';

class TodoList with ChangeNotifier {
  List<dynamic> _todoList = [];
  List<dynamic> get todoList => _todoList;

  Future<void> getTodoList() async {
    _todoList = await fetchTodoList();
    notifyListeners();
  }
}
