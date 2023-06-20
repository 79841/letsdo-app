import 'package:flutter/material.dart';
import 'package:ksica/component/to_do.dart';
import 'package:provider/provider.dart';
import '../Layout/main_layout.dart';
import '../provider/check_list.dart';
import '../provider/todo_list.dart';
import '../query/check_list.dart';

class CheckListScreen extends StatefulWidget {
  const CheckListScreen({super.key});

  @override
  State<CheckListScreen> createState() => _CheckListScreenState();
}

class _CheckListScreenState extends State<CheckListScreen> {
  Future<bool> _initCheckStates() async {
    if (!mounted) return false;
    await Provider.of<TodoList>(context, listen: false).initialize();
    await Provider.of<CheckList>(context, listen: false).fetchCheckStates();
    return true;
  }

  Widget _CheckList() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: Provider.of<TodoList>(context, listen: false).todoList.map(
        (e) {
          bool isChecked = false;
          for (var v
              in Provider.of<CheckList>(context, listen: false).checkStates) {
            if (e["code"] == v["code"] && v["done"] == true) {
              isChecked = true;
            }
          }
          return ToDo(
            toDo: e,
            isChecked: isChecked,
          );
        },
      ).toList(),
    );
  }

  Widget _saveButton() {
    return ElevatedButton(
      onPressed: () => updateCheckList(
          Provider.of<CheckList>(context, listen: false).checkStates),
      child: const Text("save"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              FutureBuilder(
                future: _initCheckStates(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return _CheckList();
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
              _saveButton(),
            ],
          ),
        ),
      ),
    );
  }
}
