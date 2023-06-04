import 'package:flutter/material.dart';
import 'package:ksica/component/to_do.dart';
import 'package:ksica/const/todo_list.dart';
import '../Layout/main_layout.dart';

class CheckListScreen extends StatelessWidget {
  const CheckListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: toDoList.map((e) => ToDo(toDo: e)).toList(),
          ),
        ),
      ),
    );
  }
}
